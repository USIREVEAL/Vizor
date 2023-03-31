"
I am a glyph that represents a VZEdge. This is used as the default glyph if none is provided by
the concrete subclass of VZEdge.

I have a width.
"
Class {
	#name : #VZEdgeGlyph,
	#superclass : #VZGlyph,
	#instVars : [
		'width'
	],
	#category : #'Vizor-GUI-Glyphs'
}

{ #category : #constants }
VZEdgeGlyph class >> defaultColor [
	^ Color black
]

{ #category : #constants }
VZEdgeGlyph class >> defaultWidth [
	^ 1
]

{ #category : #'instance creation' }
VZEdgeGlyph class >> of: aVZEdge [
	self flag: #TODO.
	"Perhaps here is where metrics of VZEntity are mapped to properties?
	 Or should this be done in a second step?
	 Here we don't have easy access to the 'View Settings', or wherever will the metric mappings be stored." 
	^ self new
		entity: aVZEdge;
		yourself
]

{ #category : #initialization }
VZEdgeGlyph >> initialize [
	super initialize.
	width := self class defaultWidth.
]

{ #category : #rendering }
VZEdgeGlyph >> setPropertiesForGlyph [
	self shape
		model: self;
		width: self width;
		color: self color;
		withBorderAttachPoint.
]

{ #category : #rendering }
VZEdgeGlyph >> shapeForRoassal [
	^ RSLine new
]

{ #category : #accessing }
VZEdgeGlyph >> width [
	<vzProperty: #numerical>
	^ width
]

{ #category : #accessing }
VZEdgeGlyph >> width: anObject [
	width := anObject
]
