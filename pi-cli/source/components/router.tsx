import React, {useState} from 'react';
import {ROUTES, RouteContext} from './route.js';
import {Play} from './play.js';
import {Menu} from './menu.js';
import {References} from './references.js';
import {Stats} from './stats.js';
import {Settings} from './settings.js';

type Props = {};

export function Router({}: Props) {
	const [route, setContextValue] = useState<ROUTES>('PLAY');

	const changeRoute = (route: ROUTES) => {
		setContextValue(route);
	};

	const getRouteComponent = () => {
		switch (route) {
			case 'PLAY':
				return <Play />;
			case 'MENU':
				return <Menu />;
			case 'REFERENCE':
				return <References />;
			case 'STATS':
				return <Stats />;
			case 'SETTINGS':
				return <Settings />;
			default:
				return <Play />;
		}
	};

	return (
		<RouteContext.Provider value={{route, changeRoute}}>
			{getRouteComponent()}
		</RouteContext.Provider>
	);
}
