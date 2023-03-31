"
A VZPropertyTest is a test class for testing the behavior of VZProperty
"
Class {
	#name : #VZPropertyTest,
	#superclass : #VZTestCase,
	#instVars : [
		'property'
	],
	#category : #'Vizor-Tests-Core'
}

{ #category : #running }
VZPropertyTest >> setUp [
	super setUp.
	property := VZProperty new
		type: #binary;
		selector: #value;
		value: true.
]

{ #category : #test }
VZPropertyTest >> testAsAssociation [
	self assert: property asAssociation equals: (#value->true).
]

{ #category : #test }
VZPropertyTest >> testPrintOn [
	self assert: (String streamContents: [ :str | property printOn: str ]) equals: '#value->true'.
]
