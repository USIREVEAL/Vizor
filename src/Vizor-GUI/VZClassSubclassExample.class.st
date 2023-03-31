"
I am an example of a Vizor application.
I open a graph with all the classes in the system as nodes in the graph.
Each class is connected to its superclass by an edge.
"
Class {
	#name : #VZClassSubclassExample,
	#superclass : #VZApplicationExample,
	#category : #'Vizor-GUI-Examples'
}

{ #category : #creating }
VZClassSubclassExample class >> createGraph [
	| classes nodes subclassRelationEdges |
	classes := Collection withAllSubclasses.
	nodes := self nodesFromClasses: classes.

	subclassRelationEdges := nodes
		select: [ :each | classes includes: each model superclass ]
		thenCollect: [ :each | VZEdge between: (nodes detect: [ :n | n model = each model superclass ]) and: each ].

	^ VZGraph new
		addNodes: nodes;
		addEdges: subclassRelationEdges;
		yourself.

]

{ #category : #'private - utility' }
VZClassSubclassExample class >> nodesFromClasses: aCollectionOfClasses [
	^ aCollectionOfClasses collect: [ :each |
		(each superclass = Object)
			ifTrue: [ VZRootNode new model: each ]
			ifFalse: [
				(each subclasses isEmpty)
					ifTrue: [ VZLeafNode new model: each ]
					ifFalse: [ VZNode new model: each ].
			]
		].
]

{ #category : #'instance creation' }
VZClassSubclassExample class >> open [
	<script>
	| view graph |

	graph := self createGraph.

	view := VZViewBuilder new
		graph: graph;
		viewSpec: self viewSpecs first;
		build.

	self new view: view;
		open.
]

{ #category : #accessing }
VZClassSubclassExample class >> title [
	^ 'Class hierarchy'
]
