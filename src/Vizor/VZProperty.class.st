"
I am a property of a VZEntity or its model.

type can be:
	- #categorical
	- #numerical
	- #binary
"
Class {
	#name : #VZProperty,
	#superclass : #VZObject,
	#instVars : [
		'type',
		'value',
		'selector'
	],
	#category : #'Vizor-Core'
}

{ #category : #'instance creation' }
VZProperty class >> ofPragma: aPragma forObject: anObject [
	^ self new
			type: (aPragma argumentAt: 1);
			selector: aPragma methodSelector;
			value: (anObject perform: aPragma methodSelector);
			yourself.
]

{ #category : #accessing }
VZProperty >> = aVZProperty [
	self flag: #FIXME. "Comparing properties like this might introduce problems with custom properties. Investigate if/when this can really be the case."
	^ self hash = aVZProperty hash
]

{ #category : #converting }
VZProperty >> asAssociation [
	^ self selector -> self value.
]

{ #category : #accessing }
VZProperty >> hash [
	^ (self asAssociation printString, type printString) hash
]

{ #category : #printing }
VZProperty >> printOn: aStream [
	aStream print: self asAssociation.
]

{ #category : #accessing }
VZProperty >> selector [
	^ selector
]

{ #category : #accessing }
VZProperty >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
VZProperty >> type [
	^ type
]

{ #category : #accessing }
VZProperty >> type: anObject [
	type := anObject
]

{ #category : #accessing }
VZProperty >> value [
	^ value
]

{ #category : #accessing }
VZProperty >> value: anObject [
	value := anObject
]
