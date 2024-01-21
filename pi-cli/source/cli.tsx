#!/usr/bin/env node
import React from 'react';
import {render} from 'ink';

import {Router} from './components/router.js';
/*
const cli = meow(
	`
	Usage
	  $ pi-cli

	Options
		--name  Your name

	Examples
	  $ pi-cli --name=Jane
	  Hello, Jane
`,
	{
		importMeta: import.meta,
		flags: {
			name: {
				type: 'string',
			},
		},
	},
); */

render(<Router />);
