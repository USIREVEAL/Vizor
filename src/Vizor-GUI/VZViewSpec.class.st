"
I am a specification of a View.

I specify a collection of entity classes to be visualized and mappings to metrics and glyphs.

I collaborate with VZViewBuilder to build a VZView.

See VZApplicationExample subclasses for some examples.
"
Class {
	#name : #VZViewSpec,
	#superclass : #VZObject,
	#instVars : [
		'name',
		'entityClasses',
		'entityFilter',
		'sortingBlock',
		'glyphMappings',
		'metricMappings',
		'layoutClass'
	],
	#category : #'Vizor-GUI-Views'
}

{ #category : #'instance creation' }
VZViewSpec >> copyFromView: aVZView [
	| newSpec |
	newSpec := self copy.
	newSpec
		entityClasses: self entityClasses copy;
		entityFilter: self entityFilter copy;
		glyphMappings: aVZView entityClassToGlyphClass copy;
		layoutClass: aVZView layoutClass;
		metricMappings: aVZView entityToMetricMappingCache copy;
		name: self name copy;
		sortingBlock: aVZView sortingBlock copy.
	^ newSpec
]

{ #category : #accessing }
VZViewSpec >> entityClasses [
	^ entityClasses
]

{ #category : #accessing }
VZViewSpec >> entityClasses: aCollectionOfClasses [
	entityClasses := aCollectionOfClasses asSet
]

{ #category : #accessing }
VZViewSpec >> entityFilter [
	^ entityFilter
]

{ #category : #accessing }
VZViewSpec >> entityFilter: aBlockClosure [
	entityFilter := aBlockClosure
]

{ #category : #accessing }
VZViewSpec >> glyphMappings [
	^ glyphMappings
]

{ #category : #accessing }
VZViewSpec >> glyphMappings: aCollectionOfAssociations [
	glyphMappings := aCollectionOfAssociations asDictionary
]

{ #category : #testing }
VZViewSpec >> includesClass: aClass [
	^ self entityClasses anySatisfy: [ :each | aClass = each or: [ aClass inheritsFrom: each ] ]
]

{ #category : #initialization }
VZViewSpec >> initialize [
	super initialize.
	self entityClasses: Set new.
	self entityFilter: [ :entities | entities ].
	self glyphMappings: Dictionary new.
	self metricMappings: Dictionary new.
	self layoutClass: RSNoLayout.
	self name: 'Unnamed view'
]

{ #category : #accessing }
VZViewSpec >> layoutClass [
	^ layoutClass
]

{ #category : #accessing }
VZViewSpec >> layoutClass: anObject [
	layoutClass := anObject
]

{ #category : #accessing }
VZViewSpec >> metricMappings [
	^ metricMappings
]

{ #category : #accessing }
VZViewSpec >> metricMappings: aCollectionOfAssociations [
	metricMappings := aCollectionOfAssociations asDictionary
]

{ #category : #accessing }
VZViewSpec >> name [
	^ name
]

{ #category : #accessing }
VZViewSpec >> name: anObject [
	name := anObject
]

{ #category : #accessing }
VZViewSpec >> sortingBlock [
	^ sortingBlock
]

{ #category : #accessing }
VZViewSpec >> sortingBlock: aBlockClosure [
	sortingBlock := aBlockClosure
]
