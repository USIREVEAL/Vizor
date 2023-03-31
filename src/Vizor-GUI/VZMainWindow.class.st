"
I am a main window of the Graphical User Interface provided by Vizor.

I have a menu bar and a content pane.
"
Class {
	#name : #VZMainWindow,
	#superclass : #VZWindow,
	#instVars : [
		'menuBar',
		'contentPane',
		'metricsBar',
		'statusBar',
		'monitor',
		'view'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZMainWindow class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #menuBar expand: false;
		add: #contentPane expand: true;
		add: #metricsBar expand: false;
		add: #statusBar expand: false;
	yourself

]

{ #category : #specs }
VZMainWindow class >> defaultTitle [
	^ 'Vizor'
]

{ #category : #specs }
VZMainWindow class >> preferredExtent [
	^ 600@600
]

{ #category : #accessing }
VZMainWindow >> contentPane [
	^ contentPane
]

{ #category : #initialization }
VZMainWindow >> initialize [
	super initialize.
	
	monitor := VZMonitor new.
	menuBar := self instantiate: VZMenuBar.
	contentPane := self instantiate: VZContentPane.
	metricsBar := self instantiate: VZMetricsBar.
	statusBar := self instantiate: VZStatusBar.
	
	self monitor announcer
		when: VZViewChangedAnnouncement send: #whenViewChanged: to: self.
]

{ #category : #initialization }
VZMainWindow >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		initialExtent: self class preferredExtent;
		whenClosedDo: [
			self inform: 'Closed VZMainWindow'.
			self release. ].
	

]

{ #category : #accessing }
VZMainWindow >> menuBar [
	^ menuBar
]

{ #category : #accessing }
VZMainWindow >> menuBar: aVZMenuBar [
	menuBar := aVZMenuBar
]

{ #category : #accessing }
VZMainWindow >> monitor [
	^ monitor
]

{ #category : #accessing }
VZMainWindow >> monitor: anObject [
	monitor := anObject
]

{ #category : #'instance creation' }
VZMainWindow >> openNewWithView: aVZView [ 
	(self application new: self class)
		view: aVZView;
		openWithSpec.
]

{ #category : #showing }
VZMainWindow >> openWithSpec [
	super openWithSpec.
	statusBar setLabel: view statusInfoExtended.
	self window ifNotNil: [ :w | w title: view name ].
]

{ #category : #dependencies }
VZMainWindow >> release [
	menuBar release.
	contentPane release.
	statusBar release.
	metricsBar release.
	monitor release.
	
	self monitor announcer unsubscribe: self.
	
	super release.
	
]

{ #category : #accessing }
VZMainWindow >> renderer [
	^ self contentPane renderer
]

{ #category : #accessing }
VZMainWindow >> view [
	^ view
]

{ #category : #accessing }
VZMainWindow >> view: aVZView [
	view := aVZView.
	view container: self.
]

{ #category : #announcing }
VZMainWindow >> whenViewChanged: aVZAnnouncement [
	self window title: self view name.
]
