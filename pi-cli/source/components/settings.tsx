import React, {useContext, useEffect, useState} from 'react';
import {Text, useInput} from 'ink';
import {RouteContext} from './route.js';
import {clearStats, readStatsSize} from '../lib/db.js';

export function Settings({}) {
	const [reaload, setReload] = useState(0);
	const [statsSize, setStatsSize] = useState(0);
	const [selected, setSelected] = useState<number>(0);
	const {changeRoute} = useContext(RouteContext);

	const handleSelected = () => {
		switch (selected) {
			case 0:
				changeRoute('MENU');
				break;
			case 1:
				break;
			case 2:
				clearStats().then(() => {
					setReload(1);
				});
				break;
		}
	};

	useInput(input => {
		switch (input) {
			case '1':
				setSelected(selected => (selected === 0 ? 2 : selected - 1));
				break;
			case '2':
				setSelected(selected => (selected === 2 ? 0 : selected + 1));
				break;
			case 'q':
				handleSelected();
		}
	});

	useEffect(() => {
		readStatsSize().then(statsSize => {
			setStatsSize(statsSize);
		});
	}, [reaload]);

	const renderSelectionIndicator = (index: number) => {
		if (selected !== index) return <Text> </Text>;

		return <Text>{'►'}</Text>;
	};

	return (
		<>
			<Text>{renderSelectionIndicator(0)} Back</Text>
			<Text>{renderSelectionIndicator(1)} Keyboard lights: on</Text>
			<Text>
				{renderSelectionIndicator(2)} Clear stats ({statsSize} bytes)
			</Text>
		</>
	);
}
