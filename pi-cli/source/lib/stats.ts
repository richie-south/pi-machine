export type Entered = {
	time: Date;
	value: string;
	valid: boolean;
};

export function getStats(inputs: Entered[]) {
	const correctlyEntered = inputs.filter(input => {
		return input.valid;
	}).length;

	const incorectlyEntered = inputs.length - correctlyEntered;
	const successRate = 100 - (incorectlyEntered / inputs.length) * 100;

	return {
		correctlyEntered,
		incorectlyEntered,
		successRate: Math.floor(isNaN(successRate) ? 100 : successRate),
	};
}
