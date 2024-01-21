import React, {useContext, useRef, useState} from 'react';
import {Box, Text, useInput} from 'ink';
import {piNumbers} from '../lib/numbers.js';
import {Entered, getStats} from '../lib/stats.js';
import {RouteContext} from './route.js';
import {readStats, saveStats} from '../lib/db.js';

type Props = {};

export function Play({}: Props) {
	const startTime = useRef(new Date());
	const {changeRoute} = useContext(RouteContext);
	const [entered, setEntered] = useState<Entered[]>([]);

	const {correctlyEntered, incorectlyEntered, successRate} = getStats(entered);

	const resetGame = async () => {
		if (entered.length > 0) {
			try {
				saveStats({
					correctlyEntered,
					incorectlyEntered,
					successRate,
					longestStreak: 0,
					startTime: startTime.current,
					endTime: new Date(),
				});
			} catch (error) {
				console.error('Could not save stats', error);
			}
		}

		setEntered([]);
		startTime.current = new Date();
	};

	useInput(input => {
		const numberInputs = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
		if (numberInputs.includes(input)) {
			setEntered(entered => {
				return [
					...entered,
					{
						time: new Date(),
						value: input,
						valid: piNumbers[entered.length] === input,
					},
				];
			});
		} else if (input === 'q') {
			resetGame();
		} else if (input === 'w') {
			changeRoute('MENU');
		} else if (input === 'd' /** debug */) {
			readStats().then(stats => {
				console.log(stats);
			});
		}
	});

	return (
		<Box flexDirection="column" marginLeft={2} marginRight={2}>
			<Box>
				<Text>
					<Text bold>3.</Text>
					{entered.map((value, index) => {
						return (
							<Text key={index} color={value.valid ? undefined : 'red'}>
								{value.value}
							</Text>
						);
					})}
				</Text>
			</Box>

			<Box borderStyle="single">
				<Box>
					<Box
						flexDirection="column"
						alignItems="center"
						justifyContent="center"
					>
						<Text>{entered.length}</Text>
						<Text>digits</Text>
					</Box>
				</Box>
				<Box marginLeft={2} marginRight={2}>
					<Box
						flexDirection="column"
						alignItems="center"
						justifyContent="center"
					>
						<Text>{successRate}%</Text>
					</Box>
				</Box>
				<Box>
					<Box
						flexDirection="column"
						alignItems="center"
						justifyContent="center"
					>
						<Text>{incorectlyEntered}</Text>
						<Text>misses</Text>
					</Box>
				</Box>
			</Box>
		</Box>
	);
}
