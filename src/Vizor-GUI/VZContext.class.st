"
I am a context object that is passed to entities when they need to build the context menu.
"
Class {
	#name : #VZContext,
	#superclass : #VZObject,
	#instVars : [
		'view',
		'selection',
		'glyph',
		'entity'
	],
	#category : #'Vizor-GUI-Interaction'
}

{ #category : #accessing }
VZContext >> application [
	^ self view container application
]

{ #category : #accessing }
VZContext >> entity [
	^ entity
]

{ #category : #accessing }
VZContext >> entity: anObject [
	entity := anObject
]

{ #category : #accessing }
VZContext >> glyph [
	^ glyph
]

{ #category : #accessing }
VZContext >> glyph: anObject [
	glyph := anObject
]

{ #category : #accessing }
VZContext >> selection [
	^ selection
]

{ #category : #accessing }
VZContext >> selection: anObject [
	selection := anObject
]

{ #category : #accessing }
VZContext >> view [
	^ view
]

{ #category : #accessing }
VZContext >> view: anObject [
	view := anObject
]
