import React, {useContext, useEffect, useState} from 'react';
import {Text, useInput} from 'ink';
import {RouteContext} from './route.js';
import {Game, readStats} from '../lib/db.js';

export function Stats({}) {
	const {changeRoute} = useContext(RouteContext);
	const [stats, setStats] = useState({
		longestStreak: 0,
		nrOfGamesPalyed: 0,
	});

	useInput(input => {
		switch (input) {
			case 'q':
				changeRoute('MENU');
		}
	});

	const getLogestStreakGame = (games: Game[]): Game | undefined => {
		let longestSteakGame: Game | undefined = undefined;
		for (let index = 0; index < games.length; index++) {
			const game = games[index];

			if ((game?.longestStreak ?? 0) > (longestSteakGame?.longestStreak ?? 0)) {
				longestSteakGame = game;
			}
		}

		return longestSteakGame;
	};

	useEffect(() => {
		readStats().then(stats => {
			const nrOfGamesPalyed = stats.length;
			const longestSteakGame = getLogestStreakGame(stats);

			const longestStreak = longestSteakGame?.longestStreak ?? 0;
			setStats({
				longestStreak,
				nrOfGamesPalyed,
			});
		});
	}, []);

	return (
		<>
			<Text>Nr of games played: {stats.nrOfGamesPalyed}</Text>
			<Text>Longest streak: {stats.longestStreak}</Text>
		</>
	);
}
