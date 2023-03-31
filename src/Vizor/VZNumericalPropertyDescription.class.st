"
I am a concrete description of a numerical property. I define the minimum and maximum value, and the range.
"
Class {
	#name : #VZNumericalPropertyDescription,
	#superclass : #VZPropertyDescription,
	#instVars : [
		'min',
		'max'
	],
	#category : #'Vizor-Core'
}

{ #category : #'instance creation' }
VZNumericalPropertyDescription class >> buildFromProperties: aCollectionOfVZProperty [
	| propertiesBySelector propertyDescriptions |
	propertiesBySelector := (aCollectionOfVZProperty groupedBy: #selector).
	propertyDescriptions := OrderedCollection new.
	propertiesBySelector keysAndValuesDo: [ :aSelector :properties |
		| values propertyDescription |
		values := properties collect: #value.
		propertyDescription := self new
			selector: aSelector;
			numberOfInstances: properties size;
			min: values min;
			max: values max;
			yourself.
		propertyDescriptions add: propertyDescription. ].
	^ propertyDescriptions
]

{ #category : #printing }
VZNumericalPropertyDescription class >> symbol [
	^ #numerical
]

{ #category : #accessing }
VZNumericalPropertyDescription >> max [
	^ max
]

{ #category : #accessing }
VZNumericalPropertyDescription >> max: aNumber [
	max := aNumber
]

{ #category : #accessing }
VZNumericalPropertyDescription >> min [
	^ min
]

{ #category : #accessing }
VZNumericalPropertyDescription >> min: aNumber [
	min := aNumber
]

{ #category : #accessing }
VZNumericalPropertyDescription >> range [
	^ self max - self min
]
