import fs from 'fs/promises';

export type Game = {
	startTime: Date;
	endTime: Date;
	successRate: number;
	correctlyEntered: number;
	incorectlyEntered: number;
	longestStreak: number;
};
const statsFilePath = './source/lib/stats.json';

export async function saveStats(data: Game) {
	const stats = await readStats();
	await fs.writeFile(
		statsFilePath,
		JSON.stringify([...stats, data], null, 2),
		'utf-8',
	);
}

export async function readStats(): Promise<Game[]> {
	const statsString = await fs.readFile(statsFilePath, 'utf-8');
	const stats = JSON.parse(statsString);
	return stats;
}

export async function readStatsSize(): Promise<number> {
	const stats = await fs.stat(statsFilePath);
	const fileSizeInBytes = stats.size;
	/* const fileSizeInMb = fileSizeInBytes / (1024 * 1024); */
	return fileSizeInBytes;
}

export async function clearStats() {
	await fs.writeFile(statsFilePath, JSON.stringify([], null, 2), 'utf-8');
}
