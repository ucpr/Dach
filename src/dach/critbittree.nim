#import tables
#import sequtils, strutils

const
  pathSeqarator = '/'
  wildcard = '*'
  paramMarks = {'{', '}'}

type
  NodeObj[T] = object {.acyclic.}
    byte: int
    otherbits: char
    case isLeaf: bool
    of false: child: array[0..1, ref NodeObj[T]]
    of true:
      key: string
      when T isnot void:
        val: T

  Node[T] = ref NodeObj[T]
  CritBitTree*[T] = object
    root: Node[T]
    count: int

### CritBitTree

proc rawGet[T](c: CritBitTree[T], key: string): Node[T] =
  var it = c.root
  while it != nil:
    if not it.isLeaf:
      let ch = if it.byte < key.len: key[it.byte] else: '\0'
      let dir = (1 + (ch.ord or it.otherBits.ord)) shr 8
      it = it.child[dir]
    else:
      return if it.key == key: it else: nil

proc hasKey*[T](c: CritBitTree[T], key: string): bool {.inline.} =
  result = not (rawGet(c, key) == nil)

proc rawInsert[T](c: var CritBitTree[T], key: string): Node[T] =
  if c.root == nil:
    new c.root
    c.root.isleaf = true
    c.root.key = key
    result = c.root
  else:
    var it = c.root
    while not it.isLeaf:
      let ch = if it.byte < key.len: key[it.byte] else: '\0'
      let dir = (1 + (ch.ord or it.otherBits.ord)) shr 8
      it = it.child[dir]

    var newOtherBits = 0
    var newByte = 0
    block blockX:
      while newbyte < key.len:
        let ch = if newbyte < it.key.len: it.key[newbyte] else: '\0'
        if ch != key[newbyte]:
          newotherbits = ch.ord xor key[newbyte].ord
          break blockX
        inc newbyte
      if newbyte < it.key.len:
        newotherbits = it.key[newbyte].ord
      else:
        return it
    while (newOtherBits and (newOtherBits-1)) != 0:
      newOtherBits = newOtherBits and (newOtherBits-1)
    newOtherBits = newOtherBits xor 255
    let ch = if newByte < it.key.len: it.key[newByte] else: '\0'
    let dir = (1 + (ord(ch) or newOtherBits)) shr 8

    var inner: Node[T]
    new inner
    new result
    result.isLeaf = true
    result.key = key
    inner.otherBits = chr(newOtherBits)
    inner.byte = newByte
    inner.child[1 - dir] = result

    var wherep = addr(c.root)
    while true:
      var p = wherep[]
      if p.isLeaf: break
      if p.byte > newByte: break
      if p.byte == newByte and p.otherBits.ord > newOtherBits: break
      let ch = if p.byte < key.len: key[p.byte] else: '\0'
      let dir = (1 + (ch.ord or p.otherBits.ord)) shr 8
      wherep = addr(p.child[dir])
    inner.child[dir] = wherep[]
    wherep[] = inner
  inc c.count

proc `[]=`*[T](c: var CritBitTree[T], key: string, val: T) =
  var n = rawInsert(c, key)
  n.val = val

template get[T](c: CritBitTree[T], key: string): T =
  let n = rawGet(c, key)
  if n == nil:
    when compiles($key):
      raise newException(KeyError, "key not found: " & $key)
    else:
      raise newException(KeyError, "key not found")
  n.val

proc `[]`*[T](c: CritBitTree[T], key: string): T {.inline.} =
  get(c, key)

