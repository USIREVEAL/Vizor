"
A VZEntityTest is a test class for testing the behavior of VZEntity
"
Class {
	#name : #VZEntityTest,
	#superclass : #VZViewBasedTest,
	#category : #'Vizor-Tests-Core'
}

{ #category : #running }
VZEntityTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.

]

{ #category : #tests }
VZEntityTest >> testGraph [
	| entity |
	entity := VZEntity new.
	
	self assert: entity graph isNil.
]

{ #category : #tests }
VZEntityTest >> testInspect [
	| entity inspector |
	entity := view findNodeByModel: 1.
	entity inspect.
	inspector := GLMSystemWindow allInstances
		detect: [ :each |
			each title = 'Inspector on a VZNode (1)'
				and: [ each model isNotNil and: [ 
				each model pane ports first value = entity ] ] ]
		ifNone: [ nil ].
	
	self assert: inspector isNotNil.
	self assert: inspector model isNotNil.
	inspector close.
]

{ #category : #tests }
VZEntityTest >> testModel [
	| obj entity |
	obj := 'foo'.
	entity := VZEntity new model: obj.
	
	self assert: entity model identicalTo: obj.
]

{ #category : #tests }
VZEntityTest >> testPrintOn [

	self assert: (String streamContents: [ :str | VZEntity new printOn: str ]) equals: 'a VZEntity'.
]

{ #category : #tests }
VZEntityTest >> testPrintOnWithModel1 [

	self
		assert: (String streamContents: [ :str |
			VZEntity new model: 7;
			printOn: str ])
		equals: 'a VZEntity (7)'.
]

{ #category : #tests }
VZEntityTest >> testPrintOnWithModel2 [

	self
		assert: (String streamContents: [ :str |
			VZEntity new model: Object new;
			printOn: str ])
		equals: 'a VZEntity (an Object)'.
]

{ #category : #'testing - properties' }
VZEntityTest >> testProperties [
	| properties |
	properties := (view findNodeByModel: 1) properties.
	self assert: (properties anySatisfy: [ :each | each selector = #hasEdges and: [ each value = true ] ] ).
	self assert: (properties anySatisfy: [ :each | each selector = #numberOfEdges and: [ each value = 2 ] ] ).
	self assert: (properties anySatisfy: [ :each | each selector = #isNode and: [ each value = true ] ] ).
	self assert: (properties anySatisfy: [ :each | each selector = #isEdge and: [ each value = false ] ] ).
]

{ #category : #'testing - properties' }
VZEntityTest >> testProperties2 [
	| properties |
	properties := node4 properties.
	self assert: (properties anySatisfy: [ :each | each selector = #hasEdges and: [ each value = false ] ] ).
	self assert: (properties anySatisfy: [ :each | each selector = #isNode and: [ each value = true ] ] ).
	self assert: (properties anySatisfy: [ :each | each selector = #isEdge and: [ each value = false ] ] ).
	self assert: (properties anySatisfy: [ :each | each selector = #numberOfEdges and: [ each value = 0 ] ] ).
]

{ #category : #'testing - properties' }
VZEntityTest >> testProperties3 [
	| properties |
	properties := node1 edges first properties.
	self assert: (properties anySatisfy: [ :each | each selector = #isNode and: [ each value = false ] ] ).
	self assert: (properties anySatisfy: [ :each | each selector = #isEdge and: [ each value = true ] ] ).

]
