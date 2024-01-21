import {createContext} from 'react';

export type ROUTES =
	| 'PLAY'
	| 'LEARNING_MODE'
	| 'REFERENCE'
	| 'STATS'
	| 'SETTINGS'
	| 'MENU';

export type RouteContextType = {
	route: ROUTES;
	changeRoute: (route: ROUTES) => void;
};
export const RouteContext = createContext<RouteContextType>({
	route: 'PLAY',
	changeRoute: () => {},
});
