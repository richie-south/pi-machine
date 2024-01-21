import {Box, Text, useInput} from 'ink';
import React, {useContext, useState} from 'react';
import {piNumbers} from '../lib/numbers.js';
import {RouteContext} from './route.js';

type Props = {};

function splitStringIntoChunks(inputString: string) {
	const chunkSize = 6;
	const result = [];

	for (let i = 0; i < inputString.length; i += chunkSize) {
		result.push(inputString.slice(i, i + chunkSize));
	}

	return result;
}

export function References({}: Props) {
	const {changeRoute} = useContext(RouteContext);
	const [index, setIndex] = useState(0);
	const numberChunks = splitStringIntoChunks(piNumbers);

	useInput(input => {
		switch (input) {
			case '1':
				setIndex(index => (index > 0 ? index - 1 : 0));
				break;
			case '2':
				setIndex(index => index + 1);
				break;
			case 'q':
				changeRoute('MENU');
		}
	});

	const toRender = numberChunks.slice(index, index + 6);

	return (
		<Box flexDirection="column">
			{toRender.map((chunk, index) => (
				<Box key={index}>
					<Text>{chunk}</Text>
				</Box>
			))}
		</Box>
	);
}
