"
I am a view on a VZGraph.
I know the entities i should be able to visualize.
I know the original graph containing all the entities I can show.
"
Class {
	#name : #VZView,
	#superclass : #VZObject,
	#instVars : [
		'graph',
		'originalEntities',
		'container',
		'selection',
		'lastViewSpec',
		'nodeToGlyphCache',
		'edgeToGlyphCache',
		'entityToMetricMappingCache',
		'entityClassToGlyphClass',
		'layoutClass',
		'sortingBlock',
		'name'
	],
	#category : #'Vizor-GUI-Views'
}

{ #category : #building }
VZView class >> builder [
	^ self defaultBuilderClass new
]

{ #category : #constants }
VZView class >> defaultBuilderClass [
	^ VZViewBuilder
]

{ #category : #examples }
VZView class >> exampleForTests [
	<script: 'self exampleForTests inspect'>
	^ VZViewBuilder new
		graph: VZGraph exampleForTests;
		build
]

{ #category : #examples }
VZView class >> exampleWithGlyphs [
	<script: 'self exampleWithGlyphs inspect'>
	^ VZViewBuilder new
		graph: VZGraph exampleForTests;
		viewSpec: VZGraphWithGlyphsExample viewSpecs first;
		build
]

{ #category : #examples }
VZView class >> exampleWithMetrics [
	<script: 'self exampleWithMetrics inspect'>
	^ VZViewBuilder new
		graph: VZGraph exampleWithMetrics;
		viewSpec: VZGraphWithMetricsExample viewSpecs first;
		build
]

{ #category : #examples }
VZView class >> exampleWithMetrics2 [
	<script: 'self exampleWithMetrics2 inspect'>
	^ VZViewBuilder new
		graph: VZGraph exampleForTests;
		viewSpec: VZGraphWithMetricsExample2 viewSpecs first;
		build
]

{ #category : #layouts }
VZView class >> layoutClassDict [
	^ Dictionary newFrom: {
		#grid -> RSGridLayout .
		#circle -> RSCircleLayout .
		#tree -> RSTreeLayout .
		#force -> RSForceBasedLayout .
		#flow -> RSFlowLayout .
		#horizontalflow -> RSHorizontalFlowLayout .
		#cluster -> RSClusterLayout .
		#none -> RSNoLayout .
	}.
	
]

{ #category : #adding }
VZView >> add: aVZEntity [
	"Add an entity to a view. If the entity is not a node nor an edge signal an error."
	(aVZEntity isKindOf: VZNode) ifTrue: [ ^ self addNode: aVZEntity ].
	(aVZEntity isKindOf: VZEdge) ifTrue: [ ^ self addEdge: aVZEntity ].
	Error signal: 'Can only add VZNodes or VZEdges to a VZView. Trying to add a ' , aVZEntity class printString.

]

{ #category : #adding }
VZView >> addAll: aCollectionOfVZEntities [
	aCollectionOfVZEntities do: [ :each | self add: each ].
]

{ #category : #adding }
VZView >> addEdge: aVZEdge [
	edgeToGlyphCache at: aVZEdge ifPresent: [ ^ self ] ifAbsentPut: [ self createGlyphFor: aVZEdge ].
]

{ #category : #adding }
VZView >> addEdges: aCollectionOfVZEdges [
	aCollectionOfVZEdges do: [ :each | self addEdge: each ]
]

{ #category : #adding }
VZView >> addEntitiesOfClass: aClass [ 
	| entitiesToAdd |
	entitiesToAdd := self graph entities select: [ :each | each isKindOf: aClass ].
	self addAll: entitiesToAdd.
]

{ #category : #adding }
VZView >> addNode: aVZNode [
	self flag: #TODO. "Old implementation with at:ifPresent:ifAbsentPut: didn't work probably for a bug in OrderedDictionary. Investigate this."
	nodeToGlyphCache at: aVZNode ifPresent: [ ^ self ] ifAbsent: [ nodeToGlyphCache at: aVZNode put: (self createGlyphFor: aVZNode) ].
]

{ #category : #adding }
VZView >> addNodes: aCollectionOfVZNodes [
	aCollectionOfVZNodes do: [ :each | self addNode: each ]
]

{ #category : #adding }
VZView >> addToOriginalEntities: aCollectionOfVZEntityOrAVZEntity [
	(aCollectionOfVZEntityOrAVZEntity isKindOf: Collection)
		ifTrue: [ self originalEntities addAll: aCollectionOfVZEntityOrAVZEntity ]
		ifFalse: [ self originalEntities add: aCollectionOfVZEntityOrAVZEntity ].
]

{ #category : #announcing }
VZView >> announce: aVZAnnouncement [
	self monitor
		ifNotNil: [ :m | m announce: aVZAnnouncement ]
]

{ #category : #rendering }
VZView >> applyMetricMappings [
	"Map view-wide metrics to appropriate properties of the glyphs."
	self nodeGlyphs do: #mapMetricsToProperties.
	self edgeGlyphs do: #mapMetricsToProperties.
]

{ #category : #building }
VZView >> builder [
	^ self class builder
]

{ #category : #selecting }
VZView >> clearAndSelectAll: aCollectionOfVZGlyph [
	self selection clear.
	self selection addAll: aCollectionOfVZGlyph.
	self selectionChanged.
]

{ #category : #selecting }
VZView >> clearAndSelectAllEntities: aCollectionOfVZEntity [
	self selection clear.
	self selectAllEntities: aCollectionOfVZEntity.
	self selectionChanged.
]

{ #category : #selecting }
VZView >> clearSelection [
	self selection clear.
	self selectionChanged.
]

{ #category : #reporting }
VZView >> completeReport [
	| nodeCounts edgeCounts |
	nodeCounts := self nodeKindCounts.
	edgeCounts := self edgeKindCounts.
		
	^ String streamContents: [ :s | s
		nextPutAll: 'Nodes'; crlf;
		nextPutAll: (String crlf join: (nodeCounts collect: [ :each | each key name , ': ' , each value asString ]) );
		crlf; crlf;
		nextPutAll: 'Edges'; crlf;
		nextPutAll: (String crlf join: (edgeCounts collect: [ :each | each key name , ': ' , each value asString ]) ). ]
]

{ #category : #adding }
VZView >> connectModel: model1 andModel: model2 [
	"Connect the two nodes where node1 has model = model1 and node2 has model = model2.
	 Returns the created edge."
	| node1 node2 newEdge |

	node1 := self findNodeByModel: model1.
	node1 ifNil: [ Error signal: 'The first model does not correspond to a VZNode in the view.' ].

	node2 := self findNodeByModel: model2.
	node2 ifNil: [ Error signal: 'The second model does not correspond to a VZNode in the view.' ].
	
	newEdge := VZEdge between: node1 and: node2.
	self addEdge: newEdge.
	
	^ newEdge
]

{ #category : #accessing }
VZView >> container [
	^ container
]

{ #category : #accessing }
VZView >> container: anObject [
	container := anObject.
	self flag: #FIXME. "Unsubscribe from previous container announcer."
	
	self monitor announcer
		when: VZLayoutChangedAnnouncement send: #whenLayoutChanged: to: self.
]

{ #category : #copying }
VZView >> copyFromSelection [
	| newView selectedNodes allEdges nonDanglingEdges nonDanglingSelectedEdges |
	
	"Remove dangling edges from spawned selection"
	self flag: #TODO. "Refactor this code and extract a method useful also in VZView culling of dangling edges on render."
	selectedNodes := self selection nodes.
	allEdges := (selectedNodes flatCollect: #edges) asSet.
	nonDanglingEdges := allEdges select: [ :each | (selectedNodes includes: each node1) and: [ selectedNodes includes: each node2 ] ].
	nonDanglingSelectedEdges := nonDanglingEdges select: [ :each | self selection edges includes: each ].

	"Create a new view and add all selected entities."
	newView := self builder
		viewSpec: (self lastViewSpec copyFromView: self);
		graph: self graph;
		originalEntities: selectedNodes , nonDanglingEdges;
		visibleEntities: selectedNodes , nonDanglingSelectedEdges;
		build.
	
	newView glyphs do: [ :each | each copyPropertiesFrom: (self findGlyphForEntity: each entity) ].
	
	^ newView
]

{ #category : #adding }
VZView >> createGlyphFor: aVZEntity [
	| glyphClass glyph |
	glyphClass := self findGlyphClassForEntityClass: aVZEntity class.
	glyph := glyphClass of: aVZEntity.
	glyph view: self.
	^ glyph.
]

{ #category : #selecting }
VZView >> deselect: aVZGlyphOrVZEntity [
	| aVZGlyph |
	aVZGlyph := self getGlyph: aVZGlyphOrVZEntity.
	aVZGlyph ifNotNil: [
		self selection remove: aVZGlyph.
		self selectionChanged.
	].
]

{ #category : #selecting }
VZView >> deselectAllEntities: aCollectionOfVZEntity [
	| glyphs |
	glyphs := self findGlyphsForEntities: aCollectionOfVZEntity.
	self selection removeAll: glyphs.
	self selectionChanged.
]

{ #category : #selecting }
VZView >> deselectAllMatching: aBlockClosure [ 
	self deselectAllEntities: (self entities select: aBlockClosure).
]

{ #category : #metrics }
VZView >> directedConnectedness [
	"Normalized ratio between number of possible edges and number of actually visible edges w.r.t. a fully connected directed graph"
	| visibleNodes |
	visibleNodes := self visibleNodes size.
	(visibleNodes < 2) ifTrue: [ ^ 1.0 ].
	^ self uniqueVisibleDirectedEdgesWithoutSelfEdges size / (visibleNodes * (visibleNodes - 1))
]

{ #category : #accessing }
VZView >> edgeGlyphs [
	^ self findGlyphsForEdges: self edges.
]

{ #category : #metrics }
VZView >> edgeKindCounts [
	^ (self visibleEdges groupedBy: #class) associations
		collect: [ :each | each key -> each value size ].
]

{ #category : #accessing }
VZView >> edges [
	^ edgeToGlyphCache keys select: #isEdge.
]

{ #category : #accessing }
VZView >> entities [
	^ self nodes , self edges
]

{ #category : #accessing }
VZView >> entityClassToGlyphClass [
	^ entityClassToGlyphClass
]

{ #category : #accessing }
VZView >> entityClassToGlyphClass: anObject [
	entityClassToGlyphClass := anObject
]

{ #category : #accessing }
VZView >> entityToMetricMappingCache [
	^ entityToMetricMappingCache
]

{ #category : #accessing }
VZView >> entityToMetricMappingCache: anObject [
	entityToMetricMappingCache := anObject
]

{ #category : #'private-finding/searching' }
VZView >> findGlyphClassForEntityClass: aClass [ 
	| glyphClass |
	"Search for direct mapping."
	glyphClass := entityClassToGlyphClass at: aClass ifAbsent: [ nil ].
	glyphClass ifNotNil: [ ^ glyphClass ].
	
	"Otherwise search for mapping of a superclass."
	(aClass allSuperclassesIncluding: VZEntity) do: [ :superClass |
		glyphClass := entityClassToGlyphClass at: superClass ifAbsent: [ nil ].
		glyphClass ifNotNil: [ ^ glyphClass ] ].
	
	"Otherwise use default mapping."
	^ glyphClass := entityClassToGlyphClass at: aClass ifAbsentPut: [ aClass defaultGlyphClass ].
]

{ #category : #'finding/searching' }
VZView >> findGlyphForEdge: aVZEdge [
	^ edgeToGlyphCache at: aVZEdge ifAbsent: nil.
]

{ #category : #'finding/searching' }
VZView >> findGlyphForEntity: aVZEntity [
	aVZEntity isNode ifTrue: [ ^ self findGlyphForNode: aVZEntity ].
	aVZEntity isEdge ifTrue: [ ^ self findGlyphForEdge: aVZEntity ].
	^ nil.	
]

{ #category : #'finding/searching' }
VZView >> findGlyphForNode: aVZNode [
	^ nodeToGlyphCache at: aVZNode ifAbsent: nil.
]

{ #category : #'finding/searching' }
VZView >> findGlyphsForEdges: aCollectionOfVZEdges [
	^ aCollectionOfVZEdges collect: [ :each | self findGlyphForEdge: each ]
]

{ #category : #'finding/searching' }
VZView >> findGlyphsForEntities: aCollectionOfVZEntity [
	^ aCollectionOfVZEntity collect: [ :each |
		| glyph |
		each isNode ifTrue: [ glyph := self findGlyphForNode: each ].
		each isEdge ifTrue: [ glyph := self findGlyphForEdge: each ].
		glyph ].
]

{ #category : #'finding/searching' }
VZView >> findGlyphsForNodes: aCollectionOfVZNode [
	^ aCollectionOfVZNode collect: [ :each | self findGlyphForNode: each ].
]

{ #category : #'finding/searching' }
VZView >> findMetricMappingsForEntity: aVZEntity [
	| aClass mappings |
	aClass := aVZEntity class.
	
	"Search for direct mapping for entity class."
	mappings := entityToMetricMappingCache at: aClass ifAbsent: [ nil ].
	mappings ifNotNil: [ ^ mappings ].
	
	"Otherwise look for mappings of superclasses of entity."
	(aClass allSuperclassesIncluding: VZEntity) do: [ :superClass |
		mappings := entityToMetricMappingCache at: superClass ifAbsent: [ nil ].
		mappings ifNotNil: [ ^ mappings ] ].
	
	"Otherwise return empty mappings"
	^ OrderedCollection empty
]

{ #category : #'finding/searching' }
VZView >> findNodeByModel: model [
	^ self nodes
		detect: [ :each | each model = model ]
		ifNone: nil.
]

{ #category : #accessing }
VZView >> firstNode [
	^ self nodes first
]

{ #category : #selecting }
VZView >> getGlyph: aVZGlyphOrVZEntity [
	(aVZGlyphOrVZEntity isKindOf: VZGlyph)
		ifTrue: [ ^ aVZGlyphOrVZEntity ].
	(aVZGlyphOrVZEntity isKindOf: VZEntity)
		ifTrue: [ ^ self findGlyphForEntity: aVZGlyphOrVZEntity ].
	Error signal: 'Can only get glyphs for VZGplyphs or VZEntities. Trying to retrieve a glyph for ' , aVZGlyphOrVZEntity class printString.

]

{ #category : #accessing }
VZView >> glyphs [
	^ self nodeGlyphs , self edgeGlyphs.
]

{ #category : #accessing }
VZView >> graph [
	^ graph
]

{ #category : #accessing }
VZView >> graph: aVZGraph [
	graph := aVZGraph
]

{ #category : #metrics }
VZView >> hasMappings [
	^ entityToMetricMappingCache isEmpty
]

{ #category : #removing }
VZView >> hide: aVZGlyphOrVZEntity [
	| aVZGlyph |
	aVZGlyph := self getGlyph: aVZGlyphOrVZEntity.
	aVZGlyph ifNotNil: [ self remove: aVZGlyph entity. ].

]

{ #category : #removing }
VZView >> hideAll: aCollectionOfVZEntityGlyphsOrVZEntities [
	aCollectionOfVZEntityGlyphsOrVZEntities copy do: [ :each | self hide: each ].
]

{ #category : #removing }
VZView >> hideEntitiesOfClass: aClass [ 
	| entitiesToHide |
	entitiesToHide := self entities select: [ :each | each isKindOf: aClass ].
	self hideAll: entitiesToHide.
]

{ #category : #testing }
VZView >> includes: aVZEntity [
	^ (nodeToGlyphCache includesKey: aVZEntity) or: (edgeToGlyphCache includesKey: aVZEntity)
]

{ #category : #testing }
VZView >> includesAll: aCollectionOfVZEntity [
	^ aCollectionOfVZEntity allSatisfy: [ :each | self includes: each ]
]

{ #category : #initialization }
VZView >> initialize [
	super initialize.
	nodeToGlyphCache := OrderedDictionary new.
	edgeToGlyphCache := Dictionary new.
	entityToMetricMappingCache := Dictionary new.
	entityClassToGlyphClass := Dictionary new.
	originalEntities := Set new.

	selection := VZSelection new view: self; yourself.
]

{ #category : #selecting }
VZView >> invertSelection [
	self selection invert.
	self selectionChanged.
]

{ #category : #testing }
VZView >> isConnectedModel: model1 andModel: model2 [
	| node1 node2 |
	node1 := self findNodeByModel: model1.
	node1 ifNil: [ ^ false ].
	node2 := self findNodeByModel: model2.
	node2 ifNil: [ ^ false ].
	^ node1 isConnectedTo: node2
]

{ #category : #accessing }
VZView >> lastViewSpec [
	^ lastViewSpec
]

{ #category : #accessing }
VZView >> lastViewSpec: anObject [
	lastViewSpec := anObject
]

{ #category : #accessing }
VZView >> layoutClass [
	^ layoutClass ifNil: [ layoutClass := RSCircleLayout ]
]

{ #category : #accessing }
VZView >> layoutClass: anObject [
	layoutClass := anObject
]

{ #category : #accessing }
VZView >> monitor [
	^ self container
		ifNotNil: #monitor
		ifNil: [ nil ]
]

{ #category : #accessing }
VZView >> name [
	^ name
]

{ #category : #accessing }
VZView >> name: anObject [
	name := anObject
]

{ #category : #accessing }
VZView >> nodeGlyphs [
	^ self findGlyphsForNodes: self nodes.
]

{ #category : #metrics }
VZView >> nodeKindCounts [
	^ (self visibleNodes groupedBy: #class) associations
		collect: [ :each | each key -> each value size ].
]

{ #category : #accessing }
VZView >> nodes [
	^ nodeToGlyphCache keys select: #isNode
]

{ #category : #accessing }
VZView >> originalEntities [
	^ originalEntities
]

{ #category : #accessing }
VZView >> originalEntities: anObject [
	originalEntities := anObject
]

{ #category : #accessing }
VZView >> propertyDescriptions [
	| modelProperties glyphProperties |
	modelProperties := self entities flatCollect: #properties.
	glyphProperties := self glyphs flatCollect: #properties.
	^ VZPropertyDescription fromProperties: (modelProperties , glyphProperties).
]

{ #category : #dependencies }
VZView >> release [
	self monitor announcer unsubscribe: self.
	
	super release.
]

{ #category : #removing }
VZView >> remove: aVZEntity [
	"Remove an entity from the view. If the entity is not a node nor an edge or is not in the view, signal an error."
	(aVZEntity isKindOf: VZNode) ifTrue: [ ^ self removeNode: aVZEntity ].
	(aVZEntity isKindOf: VZEdge) ifTrue: [ ^ self removeEdge: aVZEntity ].
	Error signal: 'Can only remove VZNodes or VZEdges from a VZView. Trying to remove a ' , aVZEntity class printString.

]

{ #category : #removing }
VZView >> removeEdge: aVZEdge [
	(edgeToGlyphCache includesKey: aVZEdge) ifFalse: [ ^ self ].
	self selection remove: (edgeToGlyphCache at: aVZEdge).
	edgeToGlyphCache removeKey: aVZEdge.
]

{ #category : #adding }
VZView >> removeFromOriginalEntities: aCollectionOfVZEntityOrAVZEntity [
	(aCollectionOfVZEntityOrAVZEntity isKindOf: Collection)
		ifTrue: [ self originalEntities removeAll: aCollectionOfVZEntityOrAVZEntity ]
		ifFalse: [ self originalEntities remove: aCollectionOfVZEntityOrAVZEntity ].
]

{ #category : #removing }
VZView >> removeNode: aVZNode [
	self selection remove: (nodeToGlyphCache at: aVZNode).
	nodeToGlyphCache removeKey: aVZNode.
	aVZNode edges select: [ :each | self includes: each ] thenDo: [ :each | self removeEdge: each ].
]

{ #category : #rendering }
VZView >> renderOn: aVZRenderer [
	"Template method: do general rendering process, then call back to renderer."
	self applyMetricMappings.
	aVZRenderer renderView: self.
]

{ #category : #updating }
VZView >> resetRootGraph [
	self originalEntities: self graph entities asSet.
]

{ #category : #selecting }
VZView >> select: aVZGlyphOrVZEntity [
	| aVZGlyph |
	aVZGlyph := self getGlyph: aVZGlyphOrVZEntity.
	aVZGlyph ifNotNil: [
		self selection add: aVZGlyph.
		self selectionChanged.
	].
]

{ #category : #selecting }
VZView >> selectAllEntities: aCollectionOfVZEntity [
	| glyphs |
	glyphs := self findGlyphsForEntities: aCollectionOfVZEntity.
	self selection addAll: glyphs.
	self selectionChanged.
]

{ #category : #selecting }
VZView >> selectAllGlyphs: aCollectionOfVZGlyph [
	self selection addAll: aCollectionOfVZGlyph.
	self selectionChanged.
]

{ #category : #selecting }
VZView >> selectAllMatching: aBlockClosure [ 
	self selectAllEntities: (self entities select: aBlockClosure).
]

{ #category : #accessing }
VZView >> selection [
	^ selection
]

{ #category : #accessing }
VZView >> selection: anObject [
	selection := anObject
]

{ #category : #announcing }
VZView >> selectionChanged [
	self announce: VZSelectionChangedAnnouncement new.
]

{ #category : #accessing }
VZView >> sortingBlock [
	^ sortingBlock
]

{ #category : #accessing }
VZView >> sortingBlock: aBlockClosure [
	sortingBlock := aBlockClosure
]

{ #category : #reporting }
VZView >> statusInfo [
	^ 'Nodes: {1} - Edges: {2}' format: { self nodes size . self edges size }.
]

{ #category : #reporting }
VZView >> statusInfoExtended [
	^ 'Nodes: {1} - Edges: {2}       Selected: {3} nodes, {4} edges       Connectedness: (D) {5}% / (U) {6}%' format: {
		self nodes size .
		self edges size .
		self selection nodeGlyphs size .
		self selection edgeGlyphs size .
		(self directedConnectedness * 100.0) asFloat round: 1 .
		(self undirectedConnectedness * 100.0) asFloat round: 1 }.
]

{ #category : #selecting }
VZView >> toggleSelection: aVZGlyph [
	self selection toggleSelection: aVZGlyph.
	self selectionChanged.
]

{ #category : #selecting }
VZView >> toggleSelectionAdditive: aVZGlyph [
	self selection toggleSelectionAdditive: aVZGlyph.
	self selectionChanged.
]

{ #category : #metrics }
VZView >> undirectedConnectedness [
	"Normalized ratio between number of possible edges and number of actually visible edges w.r.t. a fully connected undirected graph"
	| visibleNodes |
	visibleNodes := self visibleNodes size.
	(visibleNodes < 2) ifTrue: [ ^ 1.0 ].
	^ self uniqueVisibleUndirectedEdgesWithoutSelfEdges size / (visibleNodes * (visibleNodes - 1) / 2)
]

{ #category : #'private - metrics' }
VZView >> uniqueVisibleDirectedEdges [
	"Collect edges as ordered pairs and remove duplicates.
	It returns edges as OrderedCollections of two nodes and not VZEdges"
	^ self visibleEdges collect: [ :each | { each node1 . each node2 } asOrderedCollection ] as: Set.

]

{ #category : #'private - metrics' }
VZView >> uniqueVisibleDirectedEdgesWithoutSelfEdges [
	"Remove self edges then collect edges as ordered pairs and remove duplicates.
	It returns edges as OrderedCollections of two nodes and not VZEdges."
	^ (self visibleEdges reject: [ :each | each node1 = each node2 ]) collect: [ :each | { each node1 . each node2 } asOrderedCollection ] as: Set.

]

{ #category : #'private - metrics' }
VZView >> uniqueVisibleUndirectedEdges [
	"Collect edges as sets of nodes and remove duplicates.
	It returns edges as Sets of two nodes and not VZEdges"
	^ self visibleEdges collect: [ :each | { each node1 . each node2 } asSet ] as: Set.

]

{ #category : #'private - metrics' }
VZView >> uniqueVisibleUndirectedEdgesWithoutSelfEdges [
	"Remove self edges then collect edges as sets of nodes and remove duplicates.
	It returns edges as Sets of two nodes and not VZEdges"
	^ (self visibleEdges reject: [ :each | each node1 = each node2 ]) collect: [ :each | { each node1 . each node2 } asSet ] as: Set.

]

{ #category : #updating }
VZView >> updateLayout: aSymbol [
	^ self layoutClass: (self class layoutClassDict
		at: aSymbol
		ifAbsent: [ Error signal: 'Unsupported layout: ', aSymbol printString. ]).
]

{ #category : #announcing }
VZView >> viewChanged [
	self announce: VZViewChangedAnnouncement new.
]

{ #category : #accessing }
VZView >> visibleEdges [
	^ self edges
]

{ #category : #accessing }
VZView >> visibleNodes [
	^ self nodes
]

{ #category : #announcing }
VZView >> whenLayoutChanged: aVZLayoutChangedAnnouncement [
	self updateLayout: aVZLayoutChangedAnnouncement layout.
	self viewChanged.
]
