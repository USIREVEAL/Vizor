"
I am a query to select VZEntity objects in a VZGraph based on aBlock.
After I have been run I contain all the VZEntities in the VZGraph that when aBlock is applied to them it returns true.
I can apply myself to a graph to update its selection with my content.
"
Class {
	#name : #VZSelectionQuery,
	#superclass : #VZObject,
	#instVars : [
		'selectionBlock',
		'result',
		'view'
	],
	#category : #'Vizor-GUI-Views'
}

{ #category : #selecting }
VZSelectionQuery >> addToSelection [
	self view selectAllEntities: self result.
]

{ #category : #selecting }
VZSelectionQuery >> applySelection [
	self view clearAndSelectAllEntities: self result.
]

{ #category : #accessing }
VZSelectionQuery >> result [
	^ result
]

{ #category : #accessing }
VZSelectionQuery >> result: anObject [
	result := anObject
]

{ #category : #querying }
VZSelectionQuery >> run [
	self result: (view entities select: [ :each | selectionBlock value: each ]).
]

{ #category : #accessing }
VZSelectionQuery >> selectionBlock [
	^ selectionBlock
]

{ #category : #accessing }
VZSelectionQuery >> selectionBlock: anObject [
	selectionBlock := anObject
]

{ #category : #accessing }
VZSelectionQuery >> view [
	^ view
]

{ #category : #accessing }
VZSelectionQuery >> view: aVZView [
	view := aVZView
]
