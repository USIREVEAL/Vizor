"
I am a window showing information on the current view.
"
Class {
	#name : #VZViewInfoWindow,
	#superclass : #VZWindow,
	#instVars : [
		'view',
		'nodesTitle',
		'edgesTitle',
		'metricsTitle',
		'nodesInfoTable',
		'edgesInfoTable',
		'metricsInfoTable'
	],
	#category : #'Vizor-GUI-Components'
}

{ #category : #specs }
VZViewInfoWindow class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #nodesTitle withConstraints: [ :c | c height: self labelHeight ];
		add: #nodesInfoTable;
		add: #edgesTitle withConstraints: [ :c | c height: self labelHeight ];
		add: #edgesInfoTable;
		add: #metricsTitle withConstraints: [ :c | c height: self labelHeight ];
		add: #metricsInfoTable;
		yourself
]

{ #category : #specs }
VZViewInfoWindow class >> defaultTitle [
	^ 'View Info'
]

{ #category : #accessing }
VZViewInfoWindow >> edgesInfoTable [
	^ edgesInfoTable
]

{ #category : #accessing }
VZViewInfoWindow >> edgesInfoTable: anObject [
	edgesInfoTable := anObject
]

{ #category : #accessing }
VZViewInfoWindow >> edgesTitle [
	^ edgesTitle
]

{ #category : #accessing }
VZViewInfoWindow >> edgesTitle: anObject [
	edgesTitle := anObject
]

{ #category : #initialization }
VZViewInfoWindow >> initialize [
	super initialize.
	
	self monitor announcer
		when: VZViewChangedAnnouncement send: #whenViewChanged: to: self.
]

{ #category : #initialization }
VZViewInfoWindow >> initializePresenters [
	self nodesTitle: (self newLabel label: 'Nodes').
	self nodesInfoTable: self newTable.
	self edgesTitle: (self newLabel label: 'Edges').
	self edgesInfoTable: self newTable.
	self metricsTitle: (self newLabel label: 'Metrics').
	self metricsInfoTable: self newTable.
	
	self nodesInfoTable
		addColumn: (SpStringTableColumn title: 'Kind' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Count' evaluated: #value);
		items: OrderedCollection empty;
		beResizable.
	
	self edgesInfoTable
		addColumn: (SpStringTableColumn title: 'Kind' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Count' evaluated: #value);
		items: OrderedCollection empty;
		beResizable.
		
	self metricsInfoTable
		addColumn: (SpStringTableColumn new title: 'Kind'; evaluated: [ :row | row first name ]);
		addColumn: (SpStringTableColumn title: 'Metric' evaluated: [ :row | row second name ]);
		addColumn: (SpStringTableColumn title: 'Property' evaluated: [ :row | row third asString ]);
		items: OrderedCollection empty;
		beResizable.
	
]

{ #category : #accessing }
VZViewInfoWindow >> metricsInfoTable [
	^ metricsInfoTable
]

{ #category : #accessing }
VZViewInfoWindow >> metricsInfoTable: anObject [
	metricsInfoTable := anObject
]

{ #category : #accessing }
VZViewInfoWindow >> metricsTitle [
	^ metricsTitle
]

{ #category : #accessing }
VZViewInfoWindow >> metricsTitle: anObject [
	metricsTitle := anObject
]

{ #category : #accessing }
VZViewInfoWindow >> nodesInfoTable [
	^ nodesInfoTable
]

{ #category : #accessing }
VZViewInfoWindow >> nodesInfoTable: anObject [
	nodesInfoTable := anObject
]

{ #category : #accessing }
VZViewInfoWindow >> nodesTitle [
	^ nodesTitle
]

{ #category : #accessing }
VZViewInfoWindow >> nodesTitle: anObject [
	nodesTitle := anObject
]

{ #category : #dependencies }
VZViewInfoWindow >> release [
	self monitor announcer unsubscribe: self.
	
	super release.
]

{ #category : #initialization }
VZViewInfoWindow >> updatePresenter [
	view ifNil: [ ^ self ].
	self nodesInfoTable items: self view nodeKindCounts.
	self edgesInfoTable items: self view edgeKindCounts.
	self metricsInfoTable items: (self view entityToMetricMappingCache associations
		flatCollect: [ :each | 
			each value collect: [ :mapping | 
				{ each key . mapping key . mapping value } ] ]).
]

{ #category : #system }
VZViewInfoWindow >> view [
	^ view
]

{ #category : #accessing }
VZViewInfoWindow >> view: anObject [
	view := anObject.
	self updatePresenter.
]

{ #category : #announcing }
VZViewInfoWindow >> whenViewChanged: aVZAnnouncement [
	self updatePresenter.
]
