# LLM Profile

> [!NOTE]
> All LLM services integrate with various language model providers (OpenAI, Anthropic, etc.)
> and require API keys to be configured in the `.env` file.

## open-webui

[![](https://img.shields.io/static/v1?message=ghcr.io/open-webui/open-webui&logo=docker&label=docker&color=blue)](https://github.com/open-webui/open-webui/pkgs/container/open-webui)
[![](https://img.shields.io/static/v1?message=open-webui/open-webui&logo=github&label=github)](https://github.com/open-webui/open-webui)
[![](https://img.shields.io/static/v1?message=openwebui.com&logo=google+chrome&label=website&color=teal)](https://openwebui.com)

<img src="https://i.imgur.com/HZJ4uOB.png" width="250" alt="Open WebUI Logo">

Open WebUI is a user-friendly, self-hosted WebUI designed to operate entirely offline.
It supports various LLM runners, including Ollama and OpenAI-compatible APIs. It's a
feature-rich alternative to ChatGPT with support for document analysis, web search,
and more.

### Configuration

Open WebUI connects to LiteLLM via the OpenAI-compatible API endpoint. Configure the
connection in the Open WebUI settings to point to the LiteLLM service.

## litellm

[![](https://img.shields.io/static/v1?message=ghcr.io/berriai/litellm&logo=docker&label=docker&color=blue)](https://github.com/BerriAI/litellm/pkgs/container/litellm)
[![](https://img.shields.io/static/v1?message=BerriAI/litellm&logo=github&label=github)](https://github.com/BerriAI/litellm)
[![](https://img.shields.io/static/v1?message=litellm.ai&logo=google+chrome&label=website&color=teal)](https://www.litellm.ai)

<img src="https://i.imgur.com/NeOLp0Q.png" width="250" alt="LiteLLM Logo">

LiteLLM is a unified interface for 100+ LLMs (OpenAI, Azure, Anthropic, Cohere, Replicate, PaLM).
It provides a single API interface to interact with multiple language model providers,
making it easy to switch between providers or use multiple models simultaneously.

### Configuration

LiteLLM is configured via [apps/litellm/config.yaml](https://github.com/juftin/homelab/blob/main/apps/litellm/config.yaml) where you
can define model providers, API keys, and other settings. The service includes a proxy
server that translates requests to different provider formats.

The stack includes:

- `litellm`: Main proxy service
- `litellm-database`: PostgreSQL for state management
- `litellm-valkey`: Redis-compatible cache (Valkey)

## chat-gpt-next-web

[![](https://img.shields.io/static/v1?message=yidadaa/chatgpt-next-web&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/yidadaa/chatgpt-next-web)
[![](https://img.shields.io/static/v1?message=ChatGPTNextWeb/ChatGPT-Next-Web&logo=github&label=github)](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web)
[![](https://img.shields.io/static/v1?message=nextchat.dev&logo=google+chrome&label=website&color=teal)](https://nextchat.dev/)

<img src="https://i.imgur.com/CtZghAF.png" width="220" alt="ChatGPT Next Web Logo">

NextChat (ChatGPT Next Web) is a well-designed ChatGPT web UI that uses the OpenAI API
to chat with language models. It's customizable, easy to use, and provides a clean
interface for interacting with language models.

### Configuration

Configure API keys in the `.env` file. The service supports OpenAI, Anthropic, and
other providers. It can also be configured to use LiteLLM as a backend for unified
access to multiple models.

## chatgpt-in-slack

[![](https://img.shields.io/static/v1?message=juftin/chatgpt-in-slack&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/juftin/chatgpt-in-slack)
[![](https://img.shields.io/static/v1?message=seratch/ChatGPT-in-Slack&logo=github&label=github)](https://github.com/seratch/ChatGPT-in-Slack)

`ChatGPT-in-Slack` is a Slack bot that uses the OpenAI API to chat with language models.
It's a great way to interact with language models directly from your Slack workspace,
providing assistance and automation capabilities within your team communication.

### Configuration

Requires Slack bot tokens and app tokens configured in the `.env` file. The bot can
be invited to channels and will respond to mentions and direct messages.
