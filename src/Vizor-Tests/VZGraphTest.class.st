"
A VZGraphTest is a test class for testing the behavior of VZGraph
"
Class {
	#name : #VZGraphTest,
	#superclass : #VZTestCase,
	#instVars : [
		'graph',
		'nodes',
		'edges'
	],
	#category : #'Vizor-Tests-Core'
}

{ #category : #running }
VZGraphTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	nodes := VZNode fromCollection: (1 to: 4).
	edges := {
		VZEdge between: nodes first and: nodes second .
		VZEdge between: nodes first and: nodes third
		} asOrderedCollection.
	graph := VZGraph new.
	
	"precondition"
	self assert: nodes first edges size equals:2.
	self assert: edges first node1 equals: nodes first.
	self assert: edges first node2 equals: nodes second.
]

{ #category : #tests }
VZGraphTest >> testAddEdge [
	graph addEdge: edges first.
	
	self assert: graph edges isNotEmpty.
	self assertCollection: graph edges hasSameElements: (edges first: 1)
]

{ #category : #tests }
VZGraphTest >> testAddEdge2 [
	"Test that added edge has link to graph."
	graph addEdge: edges first.
	
	self assert: edges first graph equals: graph.
]

{ #category : #tests }
VZGraphTest >> testAddEdges [
	graph addEdges: edges.
	
	self assert: graph edges isNotEmpty.
	self assertCollection: graph edges hasSameElements: edges
]

{ #category : #tests }
VZGraphTest >> testAddEdges2 [
	"Test that added edges have link to graph."
	graph addEdges: edges.
	
	self assert: (edges allSatisfy: [ :each | each graph = graph ]).
]

{ #category : #tests }
VZGraphTest >> testAddNode [
	graph addNode: nodes first.
	
	self assert: graph nodes isNotEmpty.
	self assertCollection: graph nodes hasSameElements: (nodes first: 1)
]

{ #category : #tests }
VZGraphTest >> testAddNode2 [
	"Test that added node has link to graph."
	graph addNode: nodes first.
	
	self assert: nodes first graph equals: graph.
]

{ #category : #tests }
VZGraphTest >> testAddNodes [
	graph addNodes: nodes.
	
	self assert: graph nodes isNotEmpty.
	self assertCollection: graph nodes hasSameElements: nodes
]

{ #category : #tests }
VZGraphTest >> testAddNodes2 [
	"Test that added nodes have link to graph."
	graph addNodes: nodes.
	
	self assert: (nodes allSatisfy: [ :each | each graph = graph ]).
]

{ #category : #tests }
VZGraphTest >> testEdges [
	self assert: graph edges isNotNil.
	self assert: graph edges isEmpty.
]

{ #category : #test }
VZGraphTest >> testEntities [
	self assert: graph entities size equals: 0.
]

{ #category : #test }
VZGraphTest >> testEntities2 [
	graph addNodes: nodes.
	graph addEdges: edges.
	self assertCollection: graph entities hasSameElements: (nodes , edges).
]

{ #category : #tests }
VZGraphTest >> testExampleWithMetrics [
	| graphWithMetrics |
	graphWithMetrics := VZGraph exampleWithMetrics.
	
	self assert: (graphWithMetrics nodes allSatisfy: [ :each | each isKindOf: VZNodeWithIntModelMetric ]).
	self assert: (graphWithMetrics edges allSatisfy: [ :each | each isKindOf: VZEdgeWithSumMetric ]).
]

{ #category : #tests }
VZGraphTest >> testNodes [
	self assert: graph nodes isNotNil.
	self assert: graph nodes isEmpty.
]

{ #category : #tests }
VZGraphTest >> testRemoveDanglingEdges [
	graph addNode: nodes first.
	graph addEdge: edges first.
	graph removeDanglingEdges.

	self assert: graph edges isEmpty.

]

{ #category : #tests }
VZGraphTest >> testRemoveDanglingEdges2 [
	"removeDanglingEdges shouldn't remove non dangling edges"
	graph addNode: nodes first.
	graph addNode: nodes second.
	graph addEdge: edges first.
	graph removeDanglingEdges.

	self assert: graph edges size equals: 1.
	self assertCollection: graph edges hasSameElements: (edges first) asOrderedCollection.

]

{ #category : #tests }
VZGraphTest >> testRemoveEdge [
	graph addEdge: edges first.
	graph removeEdge: edges first.
	
	self assert: graph edges isEmpty.
	self assert: edges first graph equals: nil.
	self assert: edges first node1 equals: nil.
	self assert: edges first node2 equals: nil.

]

{ #category : #tests }
VZGraphTest >> testRemoveEdge2 [
	graph addEdge: edges first.
	graph addEdge: edges second.
	graph removeEdge: edges first.
	
	self assert: graph edges size equals: 1.
	self assertCollection: graph edges hasSameElements: (edges second) asOrderedCollection.

]

{ #category : #tests }
VZGraphTest >> testRemoveEdges [
	graph addEdge: edges first.
	graph addEdge: edges second.
	graph removeEdges: { edges first . edges second }.
	
	self assert: graph edges isEmpty.
]

{ #category : #tests }
VZGraphTest >> testRemoveEdges2 [
	graph addEdge: edges first.
	graph addEdge: edges second.
	graph removeEdges: { edges first }.
	
	self assert: graph edges size equals: 1.
	self assertCollection: graph edges hasSameElements: (edges second) asOrderedCollection.

]

{ #category : #tests }
VZGraphTest >> testRemoveNode [
	graph addNode: nodes first.
	graph addNode: nodes second.
	graph addEdge: edges first.
	graph removeNode: nodes first.
	
	self assert: graph edges isEmpty.
	self assert: nodes first graph equals: nil.
	self assert: nodes first edges isEmpty.

]

{ #category : #tests }
VZGraphTest >> testRemoveNode2 [
	graph addNode: nodes first.
	graph addNode: nodes second.
	graph addEdge: edges first.
	graph removeNode: nodes first.
	
	self assert: graph nodes size equals: 1.
	self assertCollection: graph nodes hasSameElements: (nodes second) asOrderedCollection.
	self assert: graph edges isEmpty.

]

{ #category : #tests }
VZGraphTest >> testRemoveNodes [
	graph addNode: nodes first.
	graph addNode: nodes second.
	graph removeNodes: { nodes first . nodes second }.
	
	self assert: graph nodes isEmpty.
]

{ #category : #tests }
VZGraphTest >> testRemoveNodes2 [
	graph addNode: nodes first.
	graph addNode: nodes second.
	graph removeNodes: { nodes first }.
	
	self assert: graph nodes size equals: 1.
	self assertCollection: graph nodes hasSameElements: (nodes second) asOrderedCollection.

]
