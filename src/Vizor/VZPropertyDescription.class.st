"
I represent the abstract description of a property.
I store the selector that generates the property, as well as a count of how many property instances were used to generate this description.
Look into my subclasses for descriptions of concrete properties, with values.
"
Class {
	#name : #VZPropertyDescription,
	#superclass : #VZObject,
	#instVars : [
		'selector',
		'numberOfInstances'
	],
	#category : #'Vizor-Core'
}

{ #category : #'instance creation' }
VZPropertyDescription class >> buildFromProperties: aCollectionOfVZProperty [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
VZPropertyDescription class >> fromProperties: aCollectionOfVZProperty [
	| propertiesByType descriptions |
	propertiesByType := aCollectionOfVZProperty groupedBy: #type.
	descriptions := OrderedCollection new.
	"For each subclass, create property descriptions for all properties of the relevant type.
	 If a property type doesn't have a matching property description type, it will be ignored."
	self subclassesDo: [ :each |
		descriptions addAll: (each buildFromProperties: (propertiesByType at: each symbol ifAbsent: [ OrderedCollection empty ])) ].
	^ descriptions
]

{ #category : #printing }
VZPropertyDescription class >> symbol [
	^ self subclassResponsibility
]

{ #category : #accessing }
VZPropertyDescription >> numberOfInstances [
	^ numberOfInstances
]

{ #category : #accessing }
VZPropertyDescription >> numberOfInstances: aNumber [
	numberOfInstances := aNumber
]

{ #category : #accessing }
VZPropertyDescription >> selector [
	^ selector
]

{ #category : #accessing }
VZPropertyDescription >> selector: aSymbol [
	selector := aSymbol
]
