// $schema: "https://docs.renovatebot.com/renovate-schema.json"

module.exports = {
    repositories: [process.env.RENOVATE_REPOSITORY],
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
