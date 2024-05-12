export default {
    puppeteerOptions: {
        headless: true,
        args: ["--no-sandbox", "--disable-setuid-sandbox"],
    },
    scanner: {
        device: 'desktop'
    }
}