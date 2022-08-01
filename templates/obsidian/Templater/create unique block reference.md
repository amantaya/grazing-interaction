# create unique block reference
<%*
//v1.1: Changed to using the new "view.editor" instead of deprecated "view.sourceMode.cmEditor"

let cmEditorAct = this.app.workspace.activeLeaf.view.editor;
let curLine = cmEditorAct.getCursor().line;
cmEditorAct.setSelection({ line: curLine, ch: 0 }, { line: curLine, ch: Infinity });

function createBlockHash() {
    let result = '';
    var characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < 7; i++ ) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

let id = createBlockHash();
let block = `![[${tp.file.title}#^${id}]]`.split("\n").join("");
navigator.clipboard.writeText(block).then(text => text);
tR = tp.file.selection() + ` ^${id}`.split("\n").join("");
%>