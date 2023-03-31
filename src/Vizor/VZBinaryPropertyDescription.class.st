"
I am a concrete description of a binary property. I define the two possible values the property can take.
The second value might be nil if the set of properties I describe never contains the second value.
"
Class {
	#name : #VZBinaryPropertyDescription,
	#superclass : #VZPropertyDescription,
	#instVars : [
		'value1',
		'value2'
	],
	#category : #'Vizor-Core'
}

{ #category : #'instance creation' }
VZBinaryPropertyDescription class >> buildFromProperties: aCollectionOfVZProperty [
	| propertiesBySelector propertyDescriptions |
	propertiesBySelector := (aCollectionOfVZProperty groupedBy: #selector).
	propertyDescriptions := OrderedCollection new.
	propertiesBySelector keysAndValuesDo: [ :aSelector :properties |
		| values propertyDescription |
		values := (properties collect: #value as: Set) asOrderedCollection.
		(values size <= 2) ifFalse: [ self error: 'A binary property should only have two possible values.' ].
		propertyDescription := self new
			selector: aSelector;
			numberOfInstances: properties size;
			value1: values first;
			value2: ((values size = 2) ifTrue: [ values second ] ifFalse: [ nil ]);
			yourself.
		propertyDescriptions add: propertyDescription. ].
	^ propertyDescriptions
]

{ #category : #printing }
VZBinaryPropertyDescription class >> symbol [
	^ #binary
]

{ #category : #accessing }
VZBinaryPropertyDescription >> value1 [
	^ value1
]

{ #category : #accessing }
VZBinaryPropertyDescription >> value1: anObject [
	value1 := anObject
]

{ #category : #accessing }
VZBinaryPropertyDescription >> value2 [
	^ value2
]

{ #category : #accessing }
VZBinaryPropertyDescription >> value2: anObject [
	value2 := anObject
]
