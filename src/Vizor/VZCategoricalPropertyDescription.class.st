"
I am a concrete description of a categorical property. I define all the values the property can take.
"
Class {
	#name : #VZCategoricalPropertyDescription,
	#superclass : #VZPropertyDescription,
	#instVars : [
		'values'
	],
	#category : #'Vizor-Core'
}

{ #category : #'instance creation' }
VZCategoricalPropertyDescription class >> buildFromProperties: aCollectionOfVZProperty [
	| propertiesBySelector propertyDescriptions |
	propertiesBySelector := (aCollectionOfVZProperty groupedBy: #selector).
	propertyDescriptions := OrderedCollection new.
	propertiesBySelector keysAndValuesDo: [ :aSelector :properties |
		| values propertyDescription |
		values := properties collect: #value as: Set.
		propertyDescription := self new
			selector: aSelector;
			numberOfInstances: properties size;
			values: values;
			yourself.
		propertyDescriptions add: propertyDescription. ].
	^ propertyDescriptions
]

{ #category : #printing }
VZCategoricalPropertyDescription class >> symbol [
	^ #categorical
]

{ #category : #accessing }
VZCategoricalPropertyDescription >> values [
	^ values
]

{ #category : #accessing }
VZCategoricalPropertyDescription >> values: aCollection [
	values := aCollection
]
