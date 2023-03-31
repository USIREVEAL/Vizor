"
I am a selection helper window.

I provide basic selection features.
"
Class {
	#name : #VZSelectionWindow,
	#superclass : #VZWindow,
	#instVars : [
		'affectedEntities',
		'affectNodes',
		'affectEdges',
		'affectHidden',
		'view'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZSelectionWindow class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #affectedEntities expand: true;
		add: #affectHidden expand: false;
	yourself

]

{ #category : #specs }
VZSelectionWindow class >> defaultTitle [
	^ 'Selection helper'
]

{ #category : #initialization }
VZSelectionWindow >> initializePresenters [

	affectNodes := self newCheckBox
			label: 'Nodes';
			"whenChangedDo: [ view selection affectNodes: affectNodes state ]."
			whenChangedDo: [ self inform: 'Selection applied to nodes: ' , affectNodes state printString ].
	affectEdges := self newCheckBox
			label: 'Edges';
			"whenChangedDo: [ view selection affectEdges: affectEdges state ]."
			whenChangedDo: [ self inform: 'Selection applied to edges: ' , affectEdges state printString ].
	
	affectedEntities := self newComponentList
		addPresenter: (self newLabel label: 'Selection applies to:');
		addPresenter: affectNodes;
		addPresenter: affectEdges;
		yourself.
	affectHidden := self newCheckBox
		label: 'Apply to hidden entities';
		"whenChangedDo: [ view selection affectHidden: affectHidden state ]."
		whenChangedDo: [ self inform: 'Selection applied to hidden entities: ' , affectHidden state printString ].

]

{ #category : #accessing }
VZSelectionWindow >> view [
	^ view
]

{ #category : #accessing }
VZSelectionWindow >> view: aVZView [
	view := aVZView
]
