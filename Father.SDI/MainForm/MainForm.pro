% Copyright 

implement mainForm
    inherits formWindow
    open core, vpiDomains, ribbonControl

clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

constructors
    new : (window Parent).
clauses
    new(Parent) :-
        formWindow::new(Parent),
        generatedInitialize(),
        stdio::outputStream := messageControl_ctl:outputStream,
        createCommands(),
        ribbonControl_ctl:layout := layout,
        navigationOverlay::registerSDI(This),
        textStatusCell := statusBarCell::new(statusBarControl_ctl, 30),
        statusBarControl_ctl:cells := [textStatusCell].

facts
    textStatusCell : statusBarCell := erroneous.

class predicates
    onDocumentNew : (command Cmd).
clauses
    onDocumentNew(Cmd) :-
        logCommand(Cmd).

class predicates
    onDocumentSave : (command Cmd).
clauses
    onDocumentSave(Cmd) :-
        logCommand(Cmd).

class predicates
    onDocumentSaveAs : (command Cmd).
clauses
    onDocumentSaveAs(Cmd) :-
        logCommand(Cmd).

class predicates
    onDocumentOpen : (command Cmd).
clauses
    onDocumentOpen(Cmd) :-
        logCommand(Cmd).

class predicates
    onClipboardCut : (command Cmd).
clauses
    onClipboardCut(Cmd) :-
        logCommand(Cmd).

class predicates
    onClipboardCopy : (command Cmd).
clauses
    onClipboardCopy(Cmd) :-
        logCommand(Cmd).

class predicates
    onClipboardPaste : (command Cmd).
clauses
    onClipboardPaste(Cmd) :-
        logCommand(Cmd).

class predicates
    onEditDelete : (command Cmd).
clauses
    onEditDelete(Cmd) :-
        logCommand(Cmd).

class predicates
    onEditUndo : (command Cmd).
clauses
    onEditUndo(Cmd) :-
        logCommand(Cmd).

class predicates
    onEditRedo : (command Cmd).
clauses
    onEditRedo(Cmd) :-
        logCommand(Cmd).

class predicates
    onHelp : (command Cmd).
clauses
    onHelp(Cmd) :-
        logCommand(Cmd).

predicates
    onAbout : (command Cmd).
clauses
    onAbout(_Cmd) :-
        _ = aboutDialog::display(This).

class predicates
    logCommand : (command Cmd).
clauses
    logCommand(Cmd) :-
        stdio::writef("Command %s\n", Cmd:id).

predicates
    onDesign : (command Cmd).
clauses
    onDesign(_Cmd) :-
        DesignerDlg = ribbonDesignerDlg::new(This),
        DesignerDlg:cmdHost := This,
        DesignerDlg:designLayout := ribbonControl_ctl:layout,
        DesignerDlg:predefinedSections := ribbonControl_ctl:layout,
        DesignerDlg:show(),
        if DesignerDlg:isOk() then
            ribbonControl_ctl:layout := DesignerDlg:designLayout
        end if.

constants
    itv : ribbonControl::cmdStyle = imageAndText(vertical).
    t : ribbonControl::cmdStyle = textOnly.
    layout : ribbonControl::layout =
        [
            section("document", "&Document", toolTip::noTip, core::none,  [block([[cmd("document/new",itv), cmd("document/open",itv), cmd("document/save",itv), cmd("document/saveAs",itv)]])]),
            section("edit", "&Edit", toolTip::noTip, core::none, [block([[cmd("edit/undo",itv)], [cmd("edit/redo",itv)]])]),
            section("clipboard","&Clipboard", toolTip::noTip, core::none, [block([[cmd("clipboard/cut",itv)], [cmd("clipboard/copy",itv)], [cmd("clipboard/paste",itv)]])]),
            section("design","Desi&gn", toolTip::noTip, core::none, [block([[cmd("ribbon.design",itv)]])]),
            section("help", "&Help", toolTip::noTip, core::none, [block([[cmd("help.help",t)], [cmd("help.about",t)]])])
        ].

predicates
    createCommands : ().
clauses
    createCommands() :-
        DocumentNewCmd = command::new(This, "document/new"),
        DocumentNewCmd:category := ["document/new"],
        DocumentNewCmd:menuLabel := "&New",
        DocumentNewCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\document-new.ico"))),
        DocumentNewCmd:tipTitle := tooltip::tip("New"),
        DocumentNewCmd:run := onDocumentNew,
        DocumentNewCmd:mnemonics := [tuple(10, "N"), tuple(15, "N1"), tuple(20, "N2"), tuple(25, "N3"), tuple(30, "N4")],
        DocumentNewCmd:acceleratorKey := key(k_f7, c_Nothing),

        DocumentOpenCmd = command::new(This, "document/open"),
        DocumentOpenCmd:menuLabel := "&Open",
        DocumentOpenCmd:category := ["document/open"],
        DocumentOpenCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\document-open.ico"))),
        DocumentOpenCmd:tipTitle := tooltip::tip("Open"),
        DocumentOpenCmd:run := onDocumentOpen,
        DocumentOpenCmd:mnemonics := [tuple(10, "O"), tuple(15, "O1"), tuple(20, "O2"), tuple(25, "O3"), tuple(30, "O4")],

        DocumentSaveCmd = command::new(This, "document/save"),
        DocumentSaveCmd:category := ["document/save"],
        DocumentSaveCmd:menuLabel := "&Save",
        DocumentSaveCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\document-save.ico"))),
        DocumentSaveCmd:run := onDocumentSave,
        DocumentSaveCmd:mnemonics := [tuple(10, "S"), tuple(20, "S1")],
        DocumentSaveCmd:enabled := false,

        DocumentSaveAsCmd = command::new(This, "document/saveAs"),
        DocumentSaveAsCmd:category := ["document/saveAs"],
        DocumentSaveAsCmd:menuLabel := "Save &As...",
        DocumentSaveAsCmd:ribbonLabel := "Save As",
        DocumentSaveAsCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\document-save-as.ico"))),
        DocumentSaveAsCmd:run := onDocumentSaveAs,
        DocumentSaveAsCmd:mnemonics := [tuple(10, "A"), tuple(20, "A1")],
        DocumentSaveAsCmd:enabled := false,

        ClipboardCutCommand = command::new(This, "clipboard/cut"),
        ClipboardCutCommand:category := ["clipboard/cut"],
        ClipboardCutCommand:menuLabel := "&Cut",
        ClipboardCutCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-cut.ico"))),
        ClipboardCutCommand:run := onClipboardCut,
        ClipboardCutCommand:mnemonics := [tuple(15, "C"), tuple(20, "U"), tuple(30, "U1")],
        ClipboardCutCommand:enabled := false,
        ClipboardCutCommand:acceleratorKey := key(k_x, c_Control),

        ClipboardCopyCommand = command::new(This, "clipboard/copy"),
        ClipboardCopyCommand:category := ["clipboard/copy"],
        ClipboardCopyCommand:menuLabel := "&Copy",
        ClipboardCopyCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-copy.ico"))),
        ClipboardCopyCommand:run := onClipboardCopy,
        ClipboardCopyCommand:mnemonics := [tuple(10, "C"), tuple(30, "C1")],
        ClipboardCopyCommand:enabled := false,
        ClipboardCopyCommand:acceleratorKey := key(k_c, c_Control),

        ClipboardPasteCommand = command::new(This, "clipboard/paste"),
        ClipboardPasteCommand:category := ["clipboard/paste"],
        ClipboardPasteCommand:menuLabel := "&Paste",
        ClipboardPasteCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-paste.ico"))),
        ClipboardPasteCommand:run := onClipboardPaste,
        ClipboardPasteCommand:mnemonics := [tuple(10, "P"), tuple(30, "P1")],
        ClipboardPasteCommand:enabled := false,
        ClipboardPasteCommand:acceleratorKey := key(k_v, c_Control),

        EditDeleteCommand = command::new(This, "edit/delete"),
        EditDeleteCommand:category := ["edit/delete"],
        EditDeleteCommand:menuLabel := "&Delete",
        EditDeleteCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-delete.ico"))),
        EditDeleteCommand:run := onEditDelete,
        EditDeleteCommand:mnemonics := [tuple(10, "D"), tuple(30, "D1")],
        EditDeleteCommand:enabled := false,
        EditDeleteCommand:acceleratorKey := key(k_del, c_Nothing),

        EditUndoCommand = command::new(This, "edit/undo"),
        EditUndoCommand:category := ["edit/undo"],
        EditUndoCommand:menuLabel := "&Undo",
        EditUndoCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-undo.ico"))),
        EditUndoCommand:run := onEditUndo,
        EditUndoCommand:mnemonics := [tuple(10, "D"), tuple(30, "D1")],
        EditUndoCommand:enabled := false,
        EditUndoCommand:acceleratorKey := key(k_z, c_Control),

        EditRedoCommand = command::new(This, "edit/redo"),
        EditRedoCommand:category := ["edit/redo"],
        EditRedoCommand:menuLabel := "&Redo",
        EditRedoCommand:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\edit-redo.ico"))),
        EditRedoCommand:run := onEditRedo,
        EditRedoCommand:mnemonics := [tuple(10, "D"), tuple(30, "D1")],
        EditRedoCommand:enabled := false,
        EditRedoCommand:acceleratorKey := key(k_y, c_Control),

        DesignCmd = command::new(This, "ribbon.design"),
        DesignCmd:tipTitle := toolTip::tip("Design ribbon, sections and commands."),
        DesignCmd:menuLabel := "&Design",
        DesignCmd:icon := some(icon::createFromBinary(#bininclude(@"icons\actions\tools.ico"))),
        DesignCmd:run := onDesign,

        HelpCmd = command::new(This, "help.help"),
        HelpCmd:tipTitle := toolTip::tip("Help"),
        HelpCmd:menuLabel := "&Help",
        HelpCmd:run := onHelp,

        AboutCmd = command::new(This, "help.about"),
        AboutCmd:tipTitle := toolTip::tip("About"),
        AboutCmd:menuLabel := "&About",
        AboutCmd:run := onAbout.

% This code is maintained automatically, do not update it manually. 15:06:37-18.6.2014
facts
    ribbonControl_ctl : ribboncontrol.
    statusBarControl_ctl : statusbarcontrol.
    messageControl_ctl : messagecontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("Tahoma", 8)),
        setText("Father.SDI"),
        setRect(rct(50,40,521,474)),
        setDecoration(titlebar([closeButton,maximizeButton,minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings,wsf_ClipChildren]),
        menuSet(noMenu),
        ribbonControl_ctl := ribboncontrol::new(This),
        ribbonControl_ctl:setPosition(8, 4),
        ribbonControl_ctl:setSize(456, 18),
        ribbonControl_ctl:dockStyle := control::dockTop,
        statusBarControl_ctl := statusbarcontrol::new(This),
        statusBarControl_ctl:setPosition(8, 416),
        statusBarControl_ctl:setSize(456, 14),
        messageControl_ctl := messagecontrol::new(This),
        messageControl_ctl:setPosition(8, 286),
        messageControl_ctl:setSize(456, 124),
        messageControl_ctl:setBorder(true),
        messageControl_ctl:dockStyle := control::dockBottom.
% end of automatic code
end implement mainForm