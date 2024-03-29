"
I define class methods to add Vizor to the World Menu.
"
Class {
	#name : #VZWorldMenu,
	#superclass : #VZObject,
	#category : #'Vizor-GUI-WorldMenu'
}

{ #category : #menu }
VZWorldMenu class >> menu00VizorOn: aBuilder [
	<worldMenu>
	(aBuilder item: #VZMonitor)
		label: #Vizor;
		"icon: self roassalIcon;"
		help: 'A graph visualization framework';
		order: 778.
]

{ #category : #menu }
VZWorldMenu class >> menu01ExamplesOn: aBuilder [
	| examples |
	<worldMenu>

	(aBuilder item: #VizorExamples)
		parent: #VZMonitor;
		order: 1;
		iconName: #glamorousGo;
		label: 'Examples';
		help: 'List of example applications of Vizor'.
		
	examples := VZApplicationExample allSubclasses sorted: [ :a :b | a title < b title ].
	examples do: [ :each |
		(aBuilder item: ('VZ' , each name) asSymbol)
			parent: #VizorExamples;
			label: each title;
			help: 'Open example';
			action: [ each open ] ].
]

{ #category : #menu }
VZWorldMenu class >> menu03GithubOn: aBuilder [
	<worldMenu>
	(aBuilder item: #VizorGit)
		parent: #VZMonitor;
		order: 3;
		label: 'GitHub';
		help: 'Open Vizor GitHub page';
		icon: (self iconNamed: 'github');
		action: [ WebBrowser openOn: 'https://github.com/USIREVEAL/Vizor' ].
]
