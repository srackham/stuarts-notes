---
date: 2010-06-18 21:36:21+00:00
slug: deleting-virtualbox-snapshots
title: Deleting VirtualBox Snapshots
categories:
- VirtualBox
---


The _Discard current snapshot and state_ command dishappeared as of VirtualBox version 3.1 leaving VirtualBox with no obvious way of deleting snapshot disk state (the misnamed _Delete Snapshot_ command merges the snapshot into the parent). The good news is that you can delete snapshots using the _branched snapshots_ feature introduced in version 3.1.

<!--more-->




**_Note_**:
Throughout this post I use the word _delete_ to mean removing both the snapshot **and** the associated disk state, I use the word _merge_ to mean deleting the snapshot and merging the associated disk state into the parent (the latter refers to the misname VirtualBox _Delete Snapshot_ command and was discussed in a [previous post](http://srackham.wordpress.com/cloning-and-copying-virtualbox-virtual-machines/)).


The technique to delete snapshots involves grafting an empty snapshot at the point you want to delete to; merging snapshots down to that point; and finally merging the empty snapshot to its parent. The following screenshots should make the process a bit clearer:

  1. Here's our starting point -- the goal is to delete snapshots 3 and 4. <br>
![deleting-vbox-snapshots-1.png](/images/deleting-vbox-snapshots-1.png)

  2. Restore to snapshot 2. <br>
![deleting-vbox-snapshots-2.png](/images/deleting-vbox-snapshots-2.png)

  3. Graft a snapshot (snapshot 5) to snapshot 2. <br>
![deleting-vbox-snapshots-3.png](/images/deleting-vbox-snapshots-3.png)

  4. Restore back to snapshot 4. <br>
![deleting-vbox-snapshots-4.png](/images/deleting-vbox-snapshots-4.png)

  5. Merge snapshot 4 (i.e. use the VirtualBox _Delete Snapshot_ command). <br>
![deleting-vbox-snapshots-5.png](/images/deleting-vbox-snapshots-5.png)

  6. Merge snapshot 3 (i.e. use the VirtualBox _Delete Snapshot_ command). <br>
![deleting-vbox-snapshots-6.png](/images/deleting-vbox-snapshots-6.png)

  7. Restore to the empty snapshot 5. <br>
![deleting-vbox-snapshots-7.png](/images/deleting-vbox-snapshots-7.png)

  8. Merge the empty snapshot 5 (i.e. use the VirtualBox _Delete Snapshot_ command). This last step effectively deletes snapshots 3 and 4 disk state from snapshot 2. <br>
![deleting-vbox-snapshots-8.png](/images/deleting-vbox-snapshots-8.png)

That's it!

I discuss merging and compacting Snapshots in [this post](/posts/merging-and-compacting-virtualbox-snapshots/) (which also includes a utility (vboxmerge.py) that I wrote to merge VirtualBox snapshots).
