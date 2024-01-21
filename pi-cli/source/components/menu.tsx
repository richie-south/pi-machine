import React, {useContext, useState} from 'react';
import {Text, useInput} from 'ink';
import {ROUTES, RouteContext} from './route.js';

type Props = {};

const MenuMap: ROUTES[] = [
	'PLAY',
	'LEARNING_MODE',
	'REFERENCE',
	'STATS',
	'SETTINGS',
	'MENU',
];

export function Menu({}: Props) {
	const {changeRoute} = useContext(RouteContext);
	const [selected, setSelected] = useState<number>(0);

	useInput(input => {
		switch (input) {
			case '1':
				setSelected(selected => (selected === 0 ? 4 : selected - 1));
				break;
			case '2':
				setSelected(selected => (selected === 4 ? 0 : selected + 1));
				break;
			case 'q':
				changeRoute(MenuMap[selected] as ROUTES);
		}
	});

	const renderSelectionIndicator = (index: number) => {
		if (selected !== index) return <Text> </Text>;

		return <Text>{'►'}</Text>;
	};

	return (
		<>
			<Text>{renderSelectionIndicator(0)} Play</Text>
			<Text>{renderSelectionIndicator(1)} Learning mode</Text>
			<Text>{renderSelectionIndicator(2)} Reference</Text>
			<Text>{renderSelectionIndicator(3)} Stats</Text>
			<Text>{renderSelectionIndicator(4)} Settings</Text>
		</>
	);
}
