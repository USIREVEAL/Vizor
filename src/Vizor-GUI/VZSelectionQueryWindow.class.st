"
I am a dialog showing an interface to run a VZSelectionQuery.
"
Class {
	#name : #VZSelectionQueryWindow,
	#superclass : #VZWindow,
	#instVars : [
		'query',
		'blockBox',
		'selectionLabel',
		'runButton',
		'applySelectionButton',
		'addToSelectionButton'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZSelectionQueryWindow class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #blockBox expand: true;
		add: #selectionLabel expand: false;
		add:
			(SpBoxLayout newHorizontal
				add: #runButton expand: true;
				add: #addToSelectionButton expand: true;
				add: #applySelectionButton expand: true;
				yourself
			) expand: false;
	yourself

]

{ #category : #specs }
VZSelectionQueryWindow class >> defaultTitle [
	^ 'Selection query block'
]

{ #category : #adding }
VZSelectionQueryWindow >> addToSelection [
	self runQuery.
	query addToSelection.
]

{ #category : #adding }
VZSelectionQueryWindow >> applySelection [
	self runQuery.
	query applySelection.
]

{ #category : #initialization }
VZSelectionQueryWindow >> initialize [
	super initialize.
	query := VZSelectionQuery new.
	blockBox := self newText.
	blockBox autoAccept: true.
	blockBox text: ('[ :each |' ,
		String cr ,
		String cr ,
		String cr ,
		String cr ,
		']').
	selectionLabel := self newLabel.
	runButton := self newButton
		label: 'Run query';
		action: [ self runQuery ].
	addToSelectionButton := self newButton
		label: 'Add to selection';
		action: [ self addToSelection ].
	applySelectionButton := self newButton
		label: 'Apply to selection';
		action: [ self applySelection ].
	
]

{ #category : #running }
VZSelectionQueryWindow >> runQuery [
	query selectionBlock: (BlockClosure readFromString: blockBox text).
	query run.
	selectionLabel label: (query result printString).
]

{ #category : #accessing }
VZSelectionQueryWindow >> view: aVZView [
	query view: aVZView
]
