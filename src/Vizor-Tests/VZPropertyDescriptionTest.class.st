"
A VZPropertyDescriptionTest is a test class for testing the behavior of VZPropertyDescription
"
Class {
	#name : #VZPropertyDescriptionTest,
	#superclass : #VZTestCase,
	#instVars : [
		'properties'
	],
	#category : #'Vizor-Tests-Core'
}

{ #category : #running }
VZPropertyDescriptionTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	properties := OrderedCollection new
		add: (VZProperty new selector: #age; type: #numerical; value: 26);
		add: (VZProperty new selector: #age; type: #numerical; value: 36);
		add: (VZProperty new selector: #hairColor; type: #categorical; value: Color red);
		add: (VZProperty new selector: #hairColor; type: #categorical; value: Color purple);
		add: (VZProperty new selector: #relationshipStatus; type: #binary; value: #single);
		add: (VZProperty new selector: #relationshipStatus; type: #binary; value: #taken);
		yourself.
]

{ #category : #tests }
VZPropertyDescriptionTest >> testFromProperties [
	| descriptions |
	descriptions := VZPropertyDescription fromProperties: properties.
	
	self assert: descriptions size equals: 3.
	self assert: (descriptions collect: #class as: Set) size equals: 3.
	self assertCollection: (descriptions collect: #class) hasSameElements: VZPropertyDescription subclasses.
]

{ #category : #tests }
VZPropertyDescriptionTest >> testFromProperties2 [
	| descriptions numerical |
	descriptions := VZPropertyDescription fromProperties: properties.
	numerical := descriptions detect: [ :each | each isKindOf: VZNumericalPropertyDescription ].
	
	self assert: numerical selector equals: #age.
	self assert: numerical numberOfInstances equals: 2.
	self assert: numerical min equals: 26.
	self assert: numerical max equals: 36.
]

{ #category : #tests }
VZPropertyDescriptionTest >> testFromProperties3 [
	| descriptions categorical |
	descriptions := VZPropertyDescription fromProperties: properties.
	categorical := descriptions detect: [ :each | each isKindOf: VZCategoricalPropertyDescription ].
	
	self assert: categorical selector equals: #hairColor.
	self assert: categorical numberOfInstances equals: 2.
	self assertCollection: categorical values hasSameElements: { Color red . Color purple }.
]

{ #category : #tests }
VZPropertyDescriptionTest >> testFromProperties4 [
	| descriptions binary |
	descriptions := VZPropertyDescription fromProperties: properties.
	binary := descriptions detect: [ :each | each isKindOf: VZBinaryPropertyDescription ].
	
	self assert: binary selector equals: #relationshipStatus.
	self assert: binary numberOfInstances equals: 2.
	self assertCollection: { binary value1 . binary value2 } hasSameElements: { #single . #taken }.
]

{ #category : #tests }
VZPropertyDescriptionTest >> testFromProperties5 [
	| binaryProperties descriptions |
	"Domain: property of a chess board.
	 We test that if only one value of a binary property is present, value2 is nil."
	binaryProperties := { VZProperty new selector: #nextPlayer; type: #binary; value: #white } asOrderedCollection.
	descriptions := VZPropertyDescription fromProperties: binaryProperties.
	
	self assert: descriptions size equals: 1.
	self assert: descriptions first selector equals: #nextPlayer.
	self assert: descriptions first numberOfInstances equals: 1.
	self assertCollection: { descriptions first value1 . descriptions first value2 } hasSameElements: { #white . nil }.
]
