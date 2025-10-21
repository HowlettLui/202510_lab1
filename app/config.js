// 環境變數載入與驗證
function loadConfig() {
    const config = {
        apiKey: process.env.API_KEY,
        databaseUrl: process.env.DATABASE_URL
    };

    // 驗證必要的環境變數
    if (!config.apiKey || !config.databaseUrl) {
        throw new Error('缺少必要的環境變數設定');
    }

    return Object.freeze(config);
}

module.exports = loadConfig();
