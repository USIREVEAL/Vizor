"
I am an abstract application representing an example application of Vizor.
See my subclasses for a few examples.

I need to define class side method viewSpecs returning an array of VZViewSpecs that I will be able to display.
"
Class {
	#name : #VZApplicationExample,
	#superclass : #SpApplication,
	#instVars : [
		'mainWindow',
		'view'
	],
	#category : #'Vizor-GUI-Examples'
}

{ #category : #specs }
VZApplicationExample class >> defaultViewSpec [
	^ VZViewSpec new
		name: 'Example view (Circle layout)';
		layoutClass: RSCircleLayout.
]

{ #category : #constants }
VZApplicationExample class >> mainWindowClass [
	^ VZMainWindow
]

{ #category : #accessing }
VZApplicationExample class >> title [
	^ self name
]

{ #category : #specs }
VZApplicationExample class >> viewSpecs [
	^ {
		self defaultViewSpec .
		self defaultViewSpec
			name: 'Example view (ForceBased layout)';
			layoutClass: RSForceBasedLayout .
	} asOrderedCollection
]

{ #category : #initialization }
VZApplicationExample >> open [
	mainWindow := self newPresenter: self class mainWindowClass.
	mainWindow view: self view.
	mainWindow openWithSpec.
]

{ #category : #accessing }
VZApplicationExample >> view [
	^ view
]

{ #category : #accessing }
VZApplicationExample >> view: aVZView [
	view := aVZView
]
