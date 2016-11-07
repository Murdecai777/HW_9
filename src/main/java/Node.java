import java.util.Stack;

class Node {
    private String value;
    private String type;
    private String charBegin;
    private String charEnd;
    private String line;
    private Node leftChild, rightChild;

    public Node(){
        value="";
        type="";
        line="";
        charBegin="";
        charEnd="";
    }

    public Node(String value, String type, String line, String charBegin, String charEnd, Node  leftChild, Node rightChild){
        this.value=value;
        this.type=type;
        this.line=line;
        this.charBegin=charBegin;
        this.charEnd=charEnd;
        this.leftChild=leftChild;
        this.rightChild=rightChild;
    }

    public Node(String value, String type, String line, String charBegin, String charEnd){
        this.value=value;
        this.type=type;
        this.line=line;
        this.charBegin=charBegin;
        this.charEnd=charEnd;
    }

    public Node(String value, Node leftChild, Node rightChild){
        this.value=value;
        this.leftChild=leftChild;
        this.rightChild=rightChild;
    }

    public Node(String value, Node exp){
        this.value=value;
        this.leftChild=exp;
    }

    public Node(String value, String type, String line, String charBegin, String charEnd, Node leftChild){
        this.value=value;
        this.type=type;
        this.line=line;
        this.charBegin=charBegin;
        this.charEnd=charEnd;
        this.leftChild=leftChild;
        this.rightChild=null;
    }


    public void SetValue(String value){this.value=value;}
    public String GetValue(){return value;}
    public void SetType(String type){this.type=type;}
    public String GetType(){return type;}


    public Node GetLeftChild(){return leftChild;}
    public void SetLeftChild(Node leftChild){this.leftChild=leftChild;}
    public void SetRightChild(Node rightChild){this.rightChild=rightChild;}
    public Node GetRightChild(){return rightChild;}

    public String EvaluateToString(){
        String temp="";
        if(leftChild!=null)
            temp+=leftChild.EvaluateToString();
        temp+=value;
        if(rightChild!=null)
            temp+=rightChild.EvaluateToString();
        return temp;
    }

    public String getCharBegin() {
        return charBegin;
    }

    public String getCharEnd() {
        return charEnd;
    }

    public String getLine() {
        return line;
    }
}


class AST {
    private Node root=null;
    private Stack<Node> stack=null;

    public AST(){
        root=null;
        stack=new Stack<Node>();
    }

    public Node GetRoot(){return root;}
    public void SetRoot(Node root){this.root=root;}

    public String GetExpression(){
        return root.EvaluateToString();
    }
}