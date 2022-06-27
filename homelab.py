#!/usr/bin/env python3

"""
Homelab Command Line Interface
"""
import collections
import pathlib
import subprocess
from dataclasses import dataclass
from typing import Optional, Union, List, OrderedDict

import click

_project_dir = pathlib.Path(__file__).resolve().parent
__version__ = "0.1.0"
__prog__ = "homelab"


def run_command(command: str,
                stream_output: bool = True,
                cwd: Optional[Union[str, pathlib.Path]] = None,
                raise_error: bool = True) -> None:
    """
    Run a Shell Command
    Parameters
    ----------
    command: str
        Command to run
    stream_output: bool
        Whether to stream the output of the command
    cwd: Optional[str]
        Working directory to run command from
    raise_error: bool
        Whether to raise errors for non-zero exit codes, defaults to True
    Returns
    -------
    None
    """
    kwargs = dict(shell=True,
                  universal_newlines=True,
                  cwd=cwd,
                  stdin=subprocess.PIPE,
                  stdout=None,
                  stderr=None)
    if stream_output is False:
        kwargs.update(dict(stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE))
    child = subprocess.Popen(command, **kwargs)  # type: ignore
    _, stderr = child.communicate()
    exit_code = child.wait()
    if exit_code != 0 and raise_error is True:
        raise RuntimeError(stderr)


@dataclass
class StackConfig:
    """
    Stack Configuration
    """

    project_name: str

    @property
    def compose_file(self) -> pathlib.Path:
        """
        Stack Docker Compose File
        """
        return _project_dir.joinpath(self.project_name).joinpath("docker-compose.yaml")


def generate_docker_compose(command: str, config: StackConfig) -> str:
    compose_command = f"""
    docker-compose \\
      --project-name "{config.project_name}" \\
      --file "{config.compose_file}" \\
      --env-file "{str(_project_dir.joinpath('.env'))}" \\
      {command}
    """.strip()
    return compose_command


traefik_project = "traefik"
media_center_project = "media-center"
miscellaneous_project = "miscellaneous"

traefik_config = StackConfig(project_name=traefik_project)
media_center_config = StackConfig(project_name=media_center_project)
miscellaneous_config = StackConfig(project_name=miscellaneous_project)

config_dict: OrderedDict[str, List[StackConfig]] = collections.OrderedDict()
config_dict["traefik"] = [traefik_config]
config_dict["media-center"] = [media_center_config]
config_dict["miscellaneous"] = [miscellaneous_config]
config_dict["all"] = [
    traefik_config,
    media_center_config,
    miscellaneous_config,
]


@click.group()
@click.version_option(version=__version__, prog_name=__prog__)
def cli() -> None:
    """
    Homelab: Command Line Interface
    """
    pass


@cli.command()
@click.argument("stack")
def pull(stack: str) -> None:
    """
    Pull the Docker Containers for a Stack
    """
    configs = config_dict[stack]
    for config in configs:
        command = generate_docker_compose(command="pull", config=config)
        run_command(command=command)


@cli.command()
@click.argument("stack")
def down(stack: str) -> None:
    """
    Shut a Stack Down
    """
    configs = config_dict[stack]
    for config in configs:
        command = generate_docker_compose(command="down", config=config)
        run_command(command=command)


@cli.command()
@click.argument("stack")
def deploy(stack: str) -> None:
    """
    Deploy a Homelab Stack
    """
    configs = config_dict[stack]
    for config in configs:
        command = generate_docker_compose(command="up -d", config=config)
        run_command(command=command)


@cli.command()
@click.argument("stack")
@click.argument("command")
def docker(stack: str, command: str) -> None:
    """
    Run a Docker Compose Command
    """
    configs = config_dict[stack]
    for config in configs:
        docker_command = generate_docker_compose(command=command, config=config)
        run_command(command=docker_command)


@cli.command()
@click.argument("stack")
def update(stack: str) -> None:
    """
    Update and Redeploy a Homelab Stack
    """
    configs = config_dict[stack]
    for config in configs:
        command = generate_docker_compose(command="pull", config=config)
        run_command(command=command)
        command_2 = generate_docker_compose(command="up -d", config=config)
        run_command(command=command_2)


if __name__ == "__main__":
    cli()
