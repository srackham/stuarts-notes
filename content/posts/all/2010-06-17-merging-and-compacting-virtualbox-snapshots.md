---
date: 2010-06-17 03:34:21+00:00
slug: merging-and-compacting-virtualbox-snapshots
title: Merging and Compacting VirtualBox Snapshots
tags:
- python
- VirtualBox
---


Using the VirtualBox GUI to manually merge lots of snapshots is time consuming and fiddly so I wrote a Python script called `vboxmerge.py` to do this automatically. The script merges a snapshot branch into the base VDI with a single command (it also illustrates how easy it is to script VirtualBox using Python).

<!--more-->




**_Important_**:
**This post is obsolete**: a much easier way is to use the VirtualBox VM _Clone_ command -- see _Update December 2013: An easier way to merge snapshots_ in my [Cloning and Copying VirtualBox virtual machines](http://srackham.wordpress.com/cloning-and-copying-virtualbox-virtual-machines/) blog post.


The more VirtualBox snapshots you have the more disk space you consume. Snapshot VDIs grow with every previously unallocated guest OS write and it's not long before the total size of a machine's base VDI plus snapshots exceeds than the machines logical HDD size (this is a very good reason why it's not a good idea to oversize your hard disks).

Here's an example of the savings on one of my Windows XP guests (it has a 50GB logical HDD):

_Before merge_:
     Base VDI plus 13 snapshots totaling 90.1GB

_After merge_:
     Base VDI 46.0GB

_After zeroing and compacting_:
     8.1GB (see _Compacting VDIs_ below). 

The merge almost halved the size; the compaction brought it to to below 10% of the original total size.

Compacting without first zeroing out free space on the guest file system generally provides no or very little benefit.

If you're unfamiliar with the workings of VirtualBox snapshots and VDIs there is a great set of FAQs and [Tutorial: All about VDIs](http://forums.virtualbox.org/viewtopic.php?p=29272#29272) in the VBox forums.



## Merging the Snapshots

  * Snapshots are merged starting with the current snapshot, then moving through the parents, until all parent snapshots have been merged into the base VDI. The `--skip=N` and `--count=N` options limit the merge to a snapshot subset. 
  * Snapshots with multiple child VDIs will not be merged, processing will stop if this situation is encountered. In this context the _Current State_ is counted as a child which explains why you can't merge the current snapshot if it has a child snapshot. To continue merging _Restore_ the blocking branch's most recent snapshot and rerun _vboxmerge_. 
  * The `--compact` option compacts the machine's base VDI. 
  * The `--snapshot` option creates a base snapshot following the merge. 
  * The `--discard-currentstate` option discards the machine's current state before merging. 
  * Run `python vboxmerge.py --help` to display command options. 

To merge snapshots into the base VDI just run the script specifying the machine name e.g.
    
    python vboxmerge.py "My Machine"


 

If the machine's snapshot tree has multiple branches you will need to run the _vboxmerge_ once for each branch to merge the entire tree. The final machine state will the that of the last merged branch.




**_Important_**:
Backup all your virtual machines before running the script and do dry runs first (using the `--dryrun` command option).
 


**_Note_**:

  * The merge starting point is the current snapshot (the snapshot attached to the _Current State_). You can change the current snapshot using the VirtualBox GUI _Restore Snapshot_ command.
  * Depending on the number and size of your snapshots this process can take quite a long time (the 13 snapshot merge I quoted previously took around three hours). 
  * After merging all snapshots the current state will also be merged into the base VDI. If this is not what you want you should include the `--discard-currentstate` option. 


**_Gotcha_**  :
If the machine being processed is selected in the VirtualBox GUI then the GUI sometimes throws and error or stops responding. No damage results and the problem can be avoided by selecting another machine in the GUI before you run _vboxmerge_.



## Compacting VDIs

Merging snapshots removes redundant shadowed blocks and will return a lot of space, but it doesn't return blocks that have previously been written but are now no longer used by the guest file system. VirtualBox processes VDIs as block devices, it knows nothing about files and file systems. The VirtualBox compact command compacts blocks of zeros so for compaction to be effective you need to zero free space from the guest operating system **before** compacting the VDI using VirtualBox.

**_Windows_**:
Use [sdelete](http://technet.microsoft.com/en-us/sysinternals/bb897443.aspx), for example to zero all unused space on drive C:
    
    sdelete.exe -c C:

**_Linux_**:
A zeroing utility for ext2 and ext3 file systems is [zerofree](http://intgat.tigress.co.uk/rmy/uml/sparsify.html) written by Ron Yorston. Your file system must be unmounted or mounted read-only before using this utility.

If you decide to compact you should zero out the free space **after** merging (if you do it before merging the zeroing will balloon the most recent snapshot and the subsequent merging will take much longer). The steps are:

  1. Merge all snapshots, for example: 
    
        python vboxmerge.py "My Machine"


 
  2. Open the merged guest machine and use an appropriate command to zero fill unused disk space. 
  3. Compact the base VDI and create a base snapshot, for example: 
    
        python vboxmerge.py --compact --snapshot "My Machine"


 

It would be nice if file systems had some sort of _zero after delete_ option to zero free disk space automatically (see [zerofree](http://intgat.tigress.co.uk/rmy/uml/sparsify.html)).

**Why create a base snapshot?**:
Because I never like to write directly to the base VDI -- creating a snapshot effectively leaves the base VDI read-only so even if your machine crashes half way through writing and corrupts the current state you can restore back to the base VDI.



## Prerequisites

This is the environment I used to develop and test `vboxmerge.py`:

  * 64 bit Windows Vista host 
  * VBox 3.2.4 
  * Python 2.6.5 (64 bit) 

You will also need to download and install [Python for Windows extensions](http://sourceforge.net/projects/pywin32/) (in my case 64bit).

Setup the Python VirtualBox bindings wrapper module (_vboxapi_) which is installed by the VirtualBox installer:

  * Open Windows _Command Prompt_ as Administrator (right-click on Command Prompt menu item and select _Run as Administrator_). 
  * Run the VBox Python setup script: 

        C:\> cd C:\Program Files\Oracle\VirtualBox\sdk\install
        C:\> C:\Python26\python.exe vboxapisetup.py install


 


Test your environment by running Python and executing:

    >>> import vboxapi
    >>> vb = vboxapi.VirtualBoxManager(None,None)


 


If there a no errors you're OK.

To print a list of your VM names and UUIDs execute this:

    >>> for m in vb.getArray(vb.vbox,'machines'):
    ...     print m.name, m.id
    ...


 




## The vboxmerge.py script

**_Important_**:
The script was developed and tested with VirtualBox 3.2.4, it might not work with other versions of VirtualBox (see Prerequisites).

``` python
#!/usr/bin/env python
'''
vboxmerge.py - Merge VirtualBox snapshots into base VDI

Run 'python vboxmerge.py --help' to display command options.

Written by Stuart Rackham, <srackham@gmail.com>
Copyright (C) 2010 Stuart Rackham. Free use of this software is
granted under the terms of the MIT License.
'''
import os, sys
import vboxapi
import pywintypes

PROG = os.path.basename(__file__)
VERSION = '0.1.1'
VBOX = vboxapi.VirtualBoxReflectionInfo(False)  # VirtualBox constants.


def out(fmt, *args):
    if not OPTIONS.quiet:
        sys.stdout.write((fmt % args))

def die(msg, exitcode=1):
    OPTIONS.quiet = False
    out('ERROR: %s\n', msg)
    sys.exit(exitcode)

def runcmd(async_cmd, *args):
    '''
    Run the bound asynchronous method async_cmd with arguments args.
    Display progress and return once the command has completed.
    If an error occurs print the error and exit the program.
    '''
    if not OPTIONS.dryrun:
        try:
            progress = async_cmd(*args)
            while not progress.completed:
                progress.waitForCompletion(30000)   # Update progress every 30 seconds.
                out('%s%% ', progress.percent)
            out('\n')
        except pywintypes.com_error, e:
            die(e.args[2][2])   # Print COM error textual description and exit.

def vboxmerge(machine_name):
    '''
    Merge snapshots using global OPTIONS.
    '''
    vbm = vboxapi.VirtualBoxManager(None, None)
    vbox = vbm.vbox
    try:
        mach = vbox.findMachine(machine_name)
    except pywintypes.com_error:
        die('machine not found: %s' % machine_name)
    out('\nmachine: %s: %s\n', mach.name, mach.id)
    if mach.state != VBOX.MachineState_PoweredOff:
        die('machine must be powered off')
    session = vbm.mgr.getSessionObject(vbox)
    vbox.openSession(session, mach.id)
    try:
        snap = mach.currentSnapshot
        if snap:

            if OPTIONS.discard_currentstate:
                out('\ndiscarding current machine state\n')
                runcmd(session.console.restoreSnapshot, snap)

            skip = int(OPTIONS.skip)
            count = int(OPTIONS.count)
            while snap:
                parent = snap.parent
                if skip <= 0 and count > 0:
                    out('\nmerging: %s: %s\n', snap.name, snap.id)
                    runcmd(session.console.deleteSnapshot, snap.id)

                    # The deleteSnapshot API sometimes silently skips snapshots
                    # so test to make sure the snapshot is no longer valid.
                    try: snap.id
                    except pywintypes.com_error: pass
                    else:
                        if not OPTIONS.dryrun:
                            die('%s: %s: more than one child VDI' % (snap.name, snap.id))

                    count -= 1
                snap = parent
                skip -= 1
        else:
            out('no snapshots\n')

        if OPTIONS.snapshot:
            # Create a base snapshot.
            out('\ncreating base snapshot\n')
            runcmd(session.console.takeSnapshot, 'Base', 'Created by vboxmerge')

        if OPTIONS.compact:
            # Compact the base VDI.
            for attachment in mach.mediumAttachments:
                if attachment.type == VBOX.DeviceType_HardDisk:
                    base = attachment.medium.base
                    if base.type == VBOX.MediumType_Normal:
                        out('\ncompacting base VDI: %s\n', base.name)
                        runcmd(base.compact)
    finally:
        session.close()


if __name__ == '__main__':
    description = '''Merge VirtualBox snapshots into base VDI. MACHINE is the machine name.'''
    from optparse import OptionParser
    parser = OptionParser(usage='%prog [OPTIONS] MACHINE',
        version='%s %s' % (PROG,VERSION),
        description=description)
    parser.add_option('--skip', dest='skip',
        help='skip most recent N snapshots', metavar='N', default=0)
    parser.add_option('--count', dest='count',
        help='only merge N snapshots', metavar='N', default=1000)
    parser.add_option('-q', '--quiet',
        action='store_true', dest='quiet', default=False,
        help='do not display progress messages')
    parser.add_option('-n', '--dryrun',
        action='store_true', dest='dryrun', default=False,
        help='do nothing except display what would be done')
    parser.add_option( '--compact',
        action='store_true', dest='compact', default=False,
        help='compact the base VDI')
    parser.add_option( '--snapshot',
        action='store_true', dest='snapshot', default=False,
        help='create base snapshot')
    parser.add_option( '--discard-currentstate',
        action='store_true', dest='discard_currentstate', default=False,
        help='discard the current state of the MACHINE')
    if len(sys.argv) == 1:
        parser.parse_args(['--help'])
    global OPTIONS
    (OPTIONS, args) = parser.parse_args()
    vboxmerge(args[0])
```


## Other Resources

  * Virtual Box API constants in `C:\Program Files\Oracle\VirtualBox\sdk\install\vboxapi\VirtualBox_constants.py`. 
  * [VirtualBox SDK](http://dlc.sun.com/virtualbox/vboxsdkdownload.html#sdk). 
  * [an example Python VBox script](http://gui-at.blogspot.com/2009/09/how-to-clone-virtualbox-virtual-machine.html). 
  * I discuss deleting Snapshots in [this post](/posts/deleting-virtualbox-snapshots/). 
