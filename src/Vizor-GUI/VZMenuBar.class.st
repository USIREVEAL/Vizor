"
I am a menu bar.
I have a default selection of views, a list of default commands and a list of custom commands.
"
Class {
	#name : #VZMenuBar,
	#superclass : #VZComponent,
	#instVars : [
		'menuBar',
		'selectionWindow',
		'selectionQueryWindow'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZMenuBar class >> defaultLayout [
	^ SpBoxLayout newHorizontal
		add: #menuBar;
	yourself

]

{ #category : #'menu - selection' }
VZMenuBar >> deselectAllEntitiesSubMenu [
	^ self entityClassesMenuWithAction: [ :aClass | self view deselectAllMatching: [ :each | each isKindOf: aClass ] ].
]

{ #category : #menu }
VZMenuBar >> entityClassesMenuWithAction: aOneArgBlock [
	| aMenu nodeClasses edgeClasses |
	aMenu := self newMenu.
	nodeClasses := VZNode withAllSubclasses reject: #isAbstract.
	edgeClasses := VZEdge withAllSubclasses reject: #isAbstract.
	nodeClasses sort: [ :a :b | a name < b name ].
	edgeClasses sort: [ :a :b | a name < b name ].
	
	aMenu addGroup: [ :aGroup |
		edgeClasses do: [ :aClass |
			aGroup addItem: [ :item |
				item
					name: aClass name;
					action: [ aOneArgBlock value: aClass ] ] ] ].
	aMenu addGroup: [ :aGroup |
		nodeClasses do: [ :aClass |
			aGroup addItem: [ :item |
				item
					name: aClass name;
					action: [ aOneArgBlock value: aClass ] ] ] ].
	
	^ aMenu
]

{ #category : #exporting }
VZMenuBar >> exportViewPNG [
	| fileReference |
	fileReference := UIManager default
		chooseForSaveFileReference: 'Choose or create file'
		extensions: { 'png' }
		path: (PlatformResolver forCurrentPlatform desktop / self view name , 'png') pathString.
	fileReference
		ifNil: [ ^ self ]
		ifNotNil: #ensureCreateFile.
	self mainWindow renderer exportPNGToFile: fileReference.
]

{ #category : #'menu - graph' }
VZMenuBar >> graphMenu [
	^ self newMenu
		addItem: [ :item |
			item name: 'Reset';
			description: 'Reset to original graph';
			action: [ self resetGraphToRootAndRedraw: false ].
		];
		addItem: [ :item |
			item name: 'Reset and redraw';
			description: 'Reset to original graph and update current view';
			action: [ self resetGraphToRootAndRedraw: true ].
		];
		addItem: [ :item |
			item name: 'Inspect';
			description: 'Inspect the current graph';
			action: [ self inspectGraph ].
		]..
]

{ #category : #initialization }
VZMenuBar >> initialize [
	super initialize.
	menuBar := self newMenuBar.
	menuBar
		addItem: [ :item |
			item name: 'Specs';
			subMenu: self specsMenu. ];
		addItem: [ :item |
			item name: 'Layouts';
			subMenu: self layoutsMenu. ];
		addItem: [ :item |
			item name: 'Selection';
			subMenu: self selectionMenu. ];
		addItem: [ :item |
			item name: 'Graph';
			subMenu: self graphMenu. ];
		addItem: [ :item |
			item name: 'View';
			subMenu: self viewMenu. ].
]

{ #category : #'menu - graph' }
VZMenuBar >> inspectGraph [
	self view graph
		ifNil: [ self inform: 'You need to link a reference model to the view to be able to inspect it from here.' ]
		ifNotNil: [ self view graph inspect ].
]

{ #category : #'menu - layouts' }
VZMenuBar >> layoutsMenu [
	| layouts aMenu |
	layouts := { 'Circle' . 'Cluster' . 'Flow' . 'Horizontal Flow' . 'Force' . 'Grid' . 'Tree' . 'None' }.
	aMenu := self newMenu.
	layouts do: [ :each |
		| aSymbol |
		aSymbol := (each asLowercase copyReplaceAll: ' ' with: '') asSymbol.
			aMenu
				addItem: [ :item |
					item name: each;
					action: [ self monitor announce: (VZLayoutChangedAnnouncement new layout: aSymbol) ] ] ].
	^ aMenu

]

{ #category : #'menu - selection' }
VZMenuBar >> modificationGroup [
	^ [ :aGroup |
		aGroup
			addItem: [ :item |
				item
				name: 'Select all';
				description: 'Select all entities of a class';
				subMenu: self selectAllEntitiesSubMenu ];
			addItem: [ :item |
				item
				name: 'Deselect all';
				description: 'Deselect all entities of a class';
				subMenu: self deselectAllEntitiesSubMenu ];
			addItem:  [ :item |
				item name: 'Invert';
				action: [ self view invertSelection ].
			];
			addItem:  [ :item |
				item name: 'Hide all';
				action: [ self view selection hideAll ].
			];
			addItem:  [ :item |
				item name: 'Color all';
				subMenu: self paintAllSubMenu.
			] ].
]

{ #category : #creating }
VZMenuBar >> openSelectionQueryWindow [
	selectionQueryWindow := self instantiate: VZSelectionQueryWindow.
	selectionQueryWindow view: self mainWindow view.
	selectionQueryWindow openWithSpec.
]

{ #category : #creating }
VZMenuBar >> openSelectionWindow [
	selectionWindow := self instantiate: VZSelectionWindow.
	selectionWindow view: self mainWindow view.
	selectionWindow openWithSpec.
]

{ #category : #creating }
VZMenuBar >> openViewInfoWindow [
	| infoWindow |
	infoWindow := self instantiate: VZViewInfoWindow.
	infoWindow view: self view.
	infoWindow openWithSpec.
]

{ #category : #'menu - selection' }
VZMenuBar >> paintAllSubMenu [
	| aMenu colors |
	aMenu := self newMenu.
	self flag: #TODO. "This list of colors should be kept somewhere, it should also be refined to use better colors."
	colors := { Color red . Color yellow . Color green . Color cyan } asOrderedCollection sorted: #name ascending.
	colors do: [ :each |
		aMenu addItem: [ :item |
			item
				name: each name;
				action: [ self view selection paint: each ] ] ].
	^ aMenu.
]

{ #category : #'menu - view' }
VZMenuBar >> replaceViewWithSpec: aVZViewSpec [
	| newView |
	newView := (self view builder
		graph: self view graph;
		originalEntities: self view originalEntities;
		viewSpec: aVZViewSpec) build.
	self mainWindow view: newView.
	self view viewChanged.
]

{ #category : #'menu - view' }
VZMenuBar >> resetGraphToRootAndRedraw: redraw [
	| newView |
	self view resetRootGraph.
	redraw
		ifFalse: [ ^ self ].
	newView := (self view builder
		graph: self view graph;
		viewSpec: self view lastViewSpec) build.
	self mainWindow view: newView.
	self view viewChanged
]

{ #category : #'menu - selection' }
VZMenuBar >> selectAllEntitiesSubMenu [
	^ self entityClassesMenuWithAction: [ :aClass | self view selectAllMatching: [ :each | each isKindOf: aClass ] ].
]

{ #category : #'menu - selection' }
VZMenuBar >> selectionGroup [
	^ [ :aGroup |
		aGroup
			addItem:  [ :item |
				item name: 'Select';
				action: [ self openSelectionWindow ].
			];
			addItem: [ :item |
				item name: 'Query';
				action: [ self openSelectionQueryWindow ].
			];
			addItem: [ :item |
				item name: 'Clear';
				action: [ self view clearSelection ].
			];
			addItem:  [ :item |
				item name: 'Spawn';
				action: [ self mainWindow openNewWithView: self view copyFromSelection ].
			] ].
]

{ #category : #'menu - selection' }
VZMenuBar >> selectionMenu [	
	^ self newMenu
		addGroup: self selectionGroup;
		addGroup: self modificationGroup.
]

{ #category : #'menu - specs' }
VZMenuBar >> specsMenu [
	| viewSpecs aMenu |
	viewSpecs := [ self application class viewSpecs ] on: Error do: [ OrderedCollection new ].
	aMenu := self newMenu.
	viewSpecs do: [ :aViewSpec |
		aMenu
			addItem: [ :item |
				item
					name: aViewSpec name;
					action: [ self replaceViewWithSpec: aViewSpec ] ] ].
	^ aMenu
]

{ #category : #'menu - view' }
VZMenuBar >> viewAddEntitiesSubMenu [
	^ self entityClassesMenuWithAction: [ :aClass | self view addEntitiesOfClass: aClass; viewChanged ]
]

{ #category : #'menu - view' }
VZMenuBar >> viewHideEntitiesSubMenu [
	^ self entityClassesMenuWithAction: [ :aClass | self view hideEntitiesOfClass: aClass; viewChanged ]
]

{ #category : #'menu - view' }
VZMenuBar >> viewMenu [
	^ self newMenu
		addItem: [ :item |
			item
				name: 'Add';
				description: 'Add entity classes from graph';
				subMenu: self viewAddEntitiesSubMenu ];
		addItem: [ :item |
			item
				name: 'Hide';
				description: 'Hide entity classes from graph';
				subMenu: self viewHideEntitiesSubMenu ];
		addItem: [ :item |
			item
				name: 'Info';
				iconName: #smallInfo;
				description: 'Show view information';
				action: [ self openViewInfoWindow ] ];
		addItem: [ :item |
			item
				name: 'Export PNG';
				iconName: #down;
				description: 'Export the current view as a PNG';
				action: [ self exportViewPNG ] ];
		addItem: [ :item |
			item
				name: 'Inspect';
				description: 'Inspect the current view';
				iconName: #glamorousInspect;
				action: [ self view inspect ] ];
		yourself
]
