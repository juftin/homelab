// $schema: "https://docs.renovatebot.com/renovate-schema.json"

module.exports = {
    repositories: [process.env.RENOVATE_REPOSITORY],
    gitAuthor:
        "github-actions[bot] <github-actions[bot]@users.noreply.github.com>",
    onboarding: true,
    platform: "github",
    hostRules: [
        {
            matchHost: "docker.io",
            username: process.env.RENOVATE_DOCKER_USERNAME,
            password: process.env.RENOVATE_DOCKER_PASSWORD,
        },
    ],
};
