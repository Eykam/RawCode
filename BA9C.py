class Node:
    def __init__(self, data =None):
        self.data = data
        self.next = None

class List:
    def __init__(self):
        self.head = None

word = ""
with open("input",'r') as file:
    word = file.readline().rstrip("\n")

suffixes = []
for x in range(0,len(word)):
    suffixes.append(word[x::])

tree = List()
tree.head = Node(data = "root")
tree.head.next = {}

def CheckChildren(string, children):
    print("String: "+string)
    if children == {}:
        children[string] = Node(data = string)
        print(children)
        print("=========")
        return

    else:
        check = list(children)

        for x in list(children):
            print("x: "+x)
            ind = 0
            similar = ""
            check.remove(x)

            while((ind < len(string)) & (ind < len(x))):
                if (string[ind] != x[ind]):
                    break
                similar = similar + string[ind]
                ind += 1

            print("similar: " +similar)
            if (ind == 0) & (check == []):
                children[string] = Node(data=string)

            elif ind != 0:
                if ind >= len(x):
                    CheckChildren(string[ind::],children[x].next)
                    return
                else:
                    string = string[ind::]
                    children[similar] = children.pop(x,None)
                    if children[similar].next != None:
                        children[similar].next[x[ind::]] = Node(data=x[ind::])
                    else:
                        children[similar].next = {x[ind::]: Node(data=x[ind::])}

                    children[similar].next[string] = Node(data=string)
                    print(children)
                    print("new node: "+similar)
                    print(children[similar].next)
                    print("==============")
                    return
            print(children)
            print("============")


for x in suffixes:
    CheckChildren(x,tree.head.next)


# for x in suffixes:
#     curr = tree.head
#     if curr.next == None:
#         curr.next = {x:Node(data= x)}
#     else:
#
#         check = list(curr.next)
#         for suff in list(curr.next):
#             similar = ""
#             ind = 0
#
#
#             while ((ind < len(x)) & (ind < len(suff))):
#                 if suff[ind] != x[ind]:
#                     break
#
#                 similar = similar + suff[ind]
#                 ind += 1
#
#             check.remove(suff)
#             if(ind >= len(suff)):
#                 curr.next[suff].next[x[ind::]] = Node(data=x[ind::])
#
#                 break
#
#             elif ((ind == 0) & (check==[])):
#                 curr.next[x] = Node(data= x)
#
#                 break
#
#
#             elif ind != 0:
#
#                 #go through children and make sure there isnt a better matching suffix
#                 curr.next[similar] = curr.next.pop(suff)
#                 if (curr.next[similar].next) != None:
#                     for leaf in list(curr.next[similar].next):
#                         curr.next[similar].next[leaf[ind::]] = curr.next[similar].next[leaf]
#
#                     curr.next[similar].next[suff[ind::]] = Node(data = suff[ind::])
#                 else:
#                     curr.next[similar].next= {suff[ind::]:Node(data=suff[ind::])}
#
#                 curr.next[similar].next[x[ind::]] = Node(data=x[ind::])
#
#                 break
#
#         tree.head = curr


def Tree(tr):

    if tr.next == None:
        return
    else:
        for x in tr.next:
            print(x)
            Tree(tr.next[x])

Tree(tree.head)