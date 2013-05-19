# Tree with explicit undo and redo functionality
#
class Model.UndoTree extends Model.Tree

	# Constructs a new undotree.
	#
	# @param [Node] root The root node of the tree. Default is Node(null, null).
	#
	constructor: ( root ) ->
		super(root)
	
	# Has added a new node containing the object to the current branch of the tree.
	#
	# @param [Object] object The object to add to the tree.
	# @return [Node] The node containing the object.
	#
	add: ( object ) ->
		for child in @_current._children
			@_current = child if child._object is object

		@_current = super( object, @_current)
		return @_current
	
	# Moves the pointer to the active node of the current branch back a step.
	#
	# @return [Object, null] The object contained within the most recent active node.
	#
	undo: ( ) ->
		if @_current isnt @_root
			object = @_current._object
			@_current = @_current._parent
			return object
		else
			return null
	
	# Move the pointer to the active node of the current branch forward a step.
	#
	# @return [Object, null] The object contained within the now active node.
	#
	redo: ( ) ->
		if @_current._branch isnt null
			@_current = @_current._branch
			object = @_current._object
			return object
		else
			return null
	
	# Rebase a branch on a different node than it's current parent.
	#
	# @param [Node] branch The branch to rebase.
	# @param [Node] new The new parent for the branch.
	# @return [self] Chainable self
	#
	rebase: ( branch, parent) ->
		branch.rebase(parent)
		if branch is @_root
			@_root = parent
		return this
	
	# Rewinds the tree from the current node and up to the node to jump to
	#
	# @param [Model.Node] The node to jump to
	# @return [Object] An object containing two arrays of the nodes, in order of steps from the current node to the node to jump to
	jump: ( node ) ->
		todo = []
		undo = []

		# Behind the current node
		if node._creation < @_current._creation
			undo = @_getReverseTrail( node )
		# In front of current node
		else if node._creation > @_current._creation
			todo = @_getForwardTrail( node )

		@_current = node

		return {reverse: undo, forward: todo}
			
	# Gets the trail from the the current node back to the given node
	#
	_getReverseTrail:( node = @_root) ->
		undo = []

		back = @_current
		until back is node or back._parent is null
			if back is node
				break
			undo.push back
			back = back._parent
		
		return undo


	# Gets the trail from the root node to the given node, assuming it's on the current branch
	#
	# @param node [Model.Node] The node to get to
	#
	_getForwardTrail:( node ) ->
		todo = []
		
		forward = node
		until forward is @_root
			todo.unshift forward
			forward = forward._parent
		todo.unshift forward

		return todo
			

(exports ? this).Model.UndoTree = Model.UndoTree
