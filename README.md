# Contents
  - [Description](#description)
  - [Removal](#removal)
  - [FAQ](#faq)
  - [Advanced](#advanced)
  - [License](#license)
  - [Disclaimer](#disclaimer)

## Description
CleanStart is a script that will reset your Start Menu and Taskbar and apply a custom layout.

This is great for applying a new standard layout, or clearing the Candy Crush etc junk.

## Usage
If you just want to go ahead and run it, simply run (right-click and choose Run with PowerShell) **CleanStart.ps1** -- you will need to then confirm the User Account Control prompt as it will attempt to run itself with elevated privileges.<br>
Obviously you'll need to be able to run PowerShell scripts -- if it errors, you'll need to change your ExecutionPolicy.  (In PowerShell Admin, run: "Set-ExecutionPolicy RemoteSigned")

Warning: This script will wipe and replace everything pinned on your Start Menu and Taskbar.<br>
It will also overwrite C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml
<br>and it will temporarily kill the Explorer process, so any File Explorer windows will close.

For more explanation of how this works, see [Advanced](#advanced).

## Removal
Delete the files:
```text
CleanStart.ps1
C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml
```

Once it's been run, you can't go back to how you had your Start Menu and Taskbar before.  Well you can, but only by moving stuff around and pinning things to Start yourself.

## FAQ

**Q:** Should I just go ahead and run the script?<br>
**A:** You can, if you're ok with everything pinned on your Start Menu and Taskbar being changed.  Don't say I didn't warn you.

**Q:** What versions of Windows will it work on?<br>
**A:** I have tested it on many different versions of Windows 10, most recently 1803, 1809, and 1903.  In theory it should work on all versions of Windows 10.  There is a slight possibility it could work on Windows 8.1 but why would you even still have that.

**Q:** Do you use this yourself?<br>
**A:** Yes, on all my personal computers.  I also test it on quite a few different virtual machines.  I'm planning to use it at my job if allowed.

**Q:** I can't get this to work.  A blue window flashes with red text and disappears.<br>
**A:** You probably need to change your PowerShell ExecutionPolicy.  Open PowerShell as Administrator, and type:<br>
Set-ExecutionPolicy RemoteSigned
<br>(then push Enter).  Then try running it again.  If it still doesn't work, let me know.

**Q:** Nothing happened, or it changed some of the Start Menu but not to what is in the script's XML.<br>
**A:** That could mean your organization has some sort of Start Menu customization already.  Talk to your IT department.  If you're at home, contact me and let me know your problem.  I take no responsibility or liability, but I will be glad to give suggestions.  Maybe we can both learn something.

**Q:** How do I customize what it does?<br>
**A:** Edit CleanStart.ps1 (it's just text) and look for the XML between the symbols @" and "@ .  As long as you don't change the @" "@ trappings, it should work fine.  Make sure you follow proper XML syntax.  Try to imitate what's already there.

**Q:** It changed something I don't want.  What now?<br>
**A:** I warned you.  But seriously, it's just the Start Menu and the Taskbar.  You can change whatever you don't like.  Change the XML and run it again, or just pin / unpin stuff manually.

**Q:** This actually broke my computer and I'm mad.<br>
**A:** If you mean the stuff pinned on your Start Menu and Taskbar, well I warned you.  If something else... what?  You SURE it wasn't a Windows Update?  I'm not doing anything destructive.  Still, contact me and let me know your problem.  I take no responsibility or liability, but I will be glad to give suggestions.

**Q:** Can I change it and use it for my own purposes?<br>
**A:** Please do!  See [License](#license).  Do me a favor and let me know what you end up making, I'd like to know how people use it.  I would be glad to make changes to better fit others, as well.

## Advanced
The whole purpose of this script is to apply a specific layout of Start Menu and Taskbar.
Normally, we use LayoutModification.xml to do this.  We would either copy the layout to  C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml
or run
Import-StartLayout -LayoutPath "LayoutModification.xml" -MountPath "$Env:SystemDrive\"
(obviously changing LayoutPath's path to wherever you have the xml)

If you apply LayoutModification.xml while Windows is being installed or before any user has logged in, it affects all users.  The problem comes when you've already logged in -- if you apply LayoutModification.xml at that point, yes it will take effect, but only for new users created from that point on.  Your account, the one you ran it on, will show no changes.  And Microsoft claims there's no way to do anything about that -- and there are no PowerShell commands to pin or unpin items or otherwise change the Start Menu or Taskbar.

Until now!  CleanStart works by temporarily making a Start Menu and Taskbar layout MANDATORY, then turning that requirement back off.  This has the happy side effect of changing the layout, but afterward being able to customize it as normal.  (Normally mandatory layouts can't be changed.)

## License
MIT License -- See [LICENSE.md](LICENSE.md)<br>
I also ask nicely that you let me know what you think, especially if you use ideas from or modify any of the files.

## Disclaimer
I take no responsibility or liability for anything this does to your computer that you did or didn't want.  It's all open source so look at it first before using it; if you have questions, ask.<br>
I intend no harm; I make a useful thing for myself, and share it here that others may or may not find useful.  I've done my best to test this on all common configurations and I use it myself.  But computers can be unpredictable and Windows changes, so there's always the possibility of unintended behavior.<br>
Still, if something goes wrong I want to learn about it, and may offer help as well, so contact me and let me know your problem.  I will be glad to give suggestions.
