"
I am a content pane.
I know my displayed view and the presenter in which it is rendered.
I can render a graph in my view.
"
Class {
	#name : #VZContentPane,
	#superclass : #VZComponent,
	#instVars : [
		'viewPresenter',
		'renderer'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZContentPane class >> defaultLayout [
	^ SpBoxLayout newHorizontal
		add: #viewPresenter;
	yourself
]

{ #category : #initialization }
VZContentPane >> initialize [
	super initialize.
	renderer := VZRoassalCanvasRenderer owner: self.
	viewPresenter := renderer presenter.
]

{ #category : #dependencies }
VZContentPane >> release [
	renderer release.
	viewPresenter release.
	
	super release.
]

{ #category : #accessing }
VZContentPane >> renderer [
	^ renderer
]
