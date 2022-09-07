#!/usr/bin/env python3

"""
Homelab Command Line Interface
"""

import datetime
import logging
import math
import pathlib
import shutil
import subprocess
import sys
import tarfile
from dataclasses import dataclass
from os import getenv
from textwrap import dedent
from typing import List, Optional, Tuple, Union

import click
from rich import print, traceback
from rich.logging import RichHandler

_default_project_dir = str(pathlib.Path(__file__).resolve().parent)
_homelab_dir = getenv("HOMELAB_DIRECTORY", _default_project_dir)
_project_dir = pathlib.Path(_homelab_dir).resolve()
__version__ = "0.1.0"
__prog__ = "homelab"

logger = logging.getLogger(__name__)


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


build_order = {
    "traefik": 1,
    "media-center": 2,
}
subdirectories = [
    f for f in _project_dir.iterdir() if f.is_dir() and not f.name.startswith(".")
]
subdirectory_names = [
    f.name for f in subdirectories if len(list(f.glob("docker-compose.y*ml"))) > 0
]
config_dict = dict(all=[])
for directory_name in subdirectory_names:
    config = StackConfig(project_name=directory_name)
    config_dict[directory_name] = [config]
    config_dict["all"] += [config]

build_sort = lambda x: build_order.get(x.project_name, 99)
destroy_sort = lambda x: -build_order.get(x.project_name, 99)
config_dict["all"] = sorted(config_dict["all"], key=build_sort)


def run_command(
    command: str,
    stream_output: bool = True,
    cwd: Optional[Union[str, pathlib.Path]] = None,
    raise_error: bool = True,
) -> None:
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
    kwargs = dict(
        shell=True,
        universal_newlines=True,
        cwd=cwd,
        stdin=subprocess.PIPE,
        stdout=None,
        stderr=None,
    )
    if stream_output is False:
        kwargs.update(dict(stdout=subprocess.PIPE, stderr=subprocess.PIPE))
    logger.debug(command)
    child = subprocess.Popen(command, **kwargs)  # type: ignore
    stdout, stderr = child.communicate()
    exit_code = child.wait()
    if exit_code != 0 and raise_error is True:
        logger.error(command)
        raise RuntimeError(stderr)


def convert_size(size_bytes) -> str:
    """
    Convert Bytes to File Size
    """
    if size_bytes == 0:
        return "0B"
    size_name = ("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")
    i = int(math.floor(math.log(size_bytes, 1024)))
    p = math.pow(1024, i)
    s = round(size_bytes / p, 2)
    return "%s %s" % (s, size_name[i])


def generate_docker_compose(command: str, config: StackConfig) -> str:
    if isinstance(command, tuple):
        command = " ".join(command)
    compose_command = dedent(
        f"""
    docker-compose \\
      --project-name "{config.project_name}" \\
      --file "{config.compose_file}" \\
      --env-file "{str(_project_dir.joinpath('.env'))}" \\
      {command}
    """.strip()
    ).replace("    ", "")
    return compose_command


stack_arg = click.argument("stack")


def get_stacks(stack: str) -> List[StackConfig]:
    """
    Get a stack, otherwise raise a nice error
    """
    try:
        return config_dict[stack]
    except KeyError:
        ticked_keys = ["`" + key + "`" for key in config_dict.keys()]
        raise LookupError(
            "That doesn't look like a valid docker stack. "
            f"Current docker stacks include {', '.join(ticked_keys)}. Stack names "
            f"are based off of the {_project_dir} directory."
        )


@click.group()
@click.version_option(version=__version__, prog_name=__prog__)
@click.option(
    "--debug/--no-debug", default=False, help="Enable extra debugging output."
)
@click.pass_context
def cli(ctx: click.core.Context, debug: bool) -> None:
    """
    Homelab: Command Line Interface
    """
    ctx.ensure_object(dict)
    ctx.obj["DEBUG"] = debug
    log_level = "INFO" if debug is False else "DEBUG"
    logging_handler = RichHandler(
        level=logging.getLevelName(log_level),
        rich_tracebacks=True,
        omit_repeated_times=False,
        show_path=False,
    )
    logging.basicConfig(
        format="%(message)s",
        level=logging.NOTSET,
        datefmt="[%Y-%m-%d %H:%M:%S]",
        handlers=[
            logging_handler,
        ],
    )
    if debug is True:
        logger.debug("Setting up homelab debugging")
        logger.debug("Homelab Version: %s", __version__)
        logger.debug("Python Version: %s", sys.version.split(" ")[0])
        logger.debug("Platform: %s", sys.platform)
        traceback.install(show_locals=debug)


@cli.command()
def stacks() -> None:
    """
    List the Docker Stacks
    """
    for config in config_dict["all"]:
        print(f"{config.project_name}: {config.compose_file}")


@cli.command()
@stack_arg
def pull(stack: str) -> None:
    """
    Pull the Docker Containers for a Stack
    """
    configs = get_stacks(stack=stack)
    for config in configs:
        command = generate_docker_compose(command="pull", config=config)
        run_command(command=command)


@cli.command()
@stack_arg
def down(stack: str) -> None:
    """
    Shut a Stack Down
    """
    configs = get_stacks(stack=stack)
    if stack == "all":
        configs = sorted(configs, key=destroy_sort)
    for config in configs:
        command = generate_docker_compose(command="down", config=config)
        run_command(command=command)


@cli.command()
@stack_arg
def deploy(stack: str) -> None:
    """
    Deploy a Homelab Stack
    """
    configs = get_stacks(stack=stack)
    for config in configs:
        command = generate_docker_compose(command="up -d", config=config)
        run_command(command=command)


@cli.command()
@stack_arg
@click.argument("command", nargs=-1)
def docker(stack: str, command: str) -> None:
    """
    Run a Docker Compose Command
    """
    configs = get_stacks(stack=stack)
    for config in configs:
        docker_command = generate_docker_compose(command=command, config=config)
        run_command(command=docker_command)


@cli.command()
@stack_arg
def update(stack: str) -> None:
    """
    Update and Redeploy a Homelab Stack
    """
    configs = get_stacks(stack=stack)
    for config in configs:
        command = generate_docker_compose(command="pull", config=config)
        run_command(command=command)
        command_2 = generate_docker_compose(command="up -d", config=config)
        run_command(command=command_2)


def file_cleanup(directory: pathlib.Path, pattern: str, num_backups: int):
    """
    Delete Files in Old Directories
    """
    file_list = directory.glob(pattern)
    sorted_files = sorted(file_list, reverse=True)
    for file in sorted_files[num_backups:]:
        logging.info("Deleting older file, %s", file)
        file.unlink()


def _backup_stack(
    stack: StackConfig,
    destination: str,
    cleanup: bool,
    additional: Tuple[str],
    num_backups: int,
    additional_cleanup: bool,
    additional_num_backups: int,
) -> None:
    """
    Backup the Docker Stack
    """
    stack_formatted = stack.project_name.replace("-", "_")
    time_format = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    file_name = f"{stack_formatted}_backup_{time_format}.tar.gz"
    source_directory = stack.compose_file.parent
    destination_directory = pathlib.Path(destination).resolve()
    assert all((source_directory.exists(), destination_directory.exists()))
    backup_file = source_directory.parent.joinpath(file_name)
    backup_file.parent.mkdir(parents=True, exist_ok=True)
    logger.info("Backing up %s", source_directory)
    start_time = datetime.datetime.now()
    with tarfile.open(backup_file, "w:gz") as tar:
        tar.add(source_directory, arcname=source_directory.name)
    duration = datetime.datetime.now() - start_time
    file_size = convert_size(backup_file.stat().st_size)
    logger.info(f"Backup file created, %s (%s) (%s)", backup_file, file_size, duration)
    for additional_str in additional:
        additional_path = pathlib.Path(additional_str).resolve()
        assert additional_path.exists() and additional_path.is_dir()
        additional_file = additional_path.joinpath(backup_file.name)
        logger.info("Copying file to additional path: %s", additional_file)
        shutil.copy(backup_file, additional_file)
        if additional_cleanup is True:
            file_cleanup(
                directory=additional_path,
                pattern=f"{stack_formatted}_backup_*.tar.gz",
                num_backups=additional_num_backups,
            )
    destination_file = destination_directory.joinpath(backup_file.name)
    logger.info("Moving backup to storage directory: %s", destination_file)
    shutil.move(backup_file, destination_file)
    if cleanup is True:
        file_cleanup(
            directory=destination_directory,
            pattern=f"{stack_formatted}_backup_*.tar.gz",
            num_backups=num_backups,
        )


@cli.command()
@stack_arg
@click.argument("destination")
@click.option(
    "--additional",
    "-a",
    "additional",
    multiple=True,
    default=None,
    type=str,
    help="Additional directories to place a backup at",
)
@click.option(
    "--cleanup/--no-cleanup",
    default=False,
    help="Whether to delete older backup files after creating a new one",
)
@click.option(
    "--num-backups",
    "-n",
    "num_backups",
    type=int,
    default=2,
    help="Number of total backup files to retain",
)
@click.option(
    "--additional-cleanup/--additional-no-cleanup",
    "-d",
    "additional_cleanup",
    default=False,
    help="Whether to delete older backup files after creating a new one",
)
@click.option(
    "--additional-num-backups",
    "-h",
    "additional_num_backups",
    type=int,
    default=2,
    help="Number of total backup files to retain in the additional directories",
)
def backup(
    stack: str,
    destination: str,
    cleanup: bool,
    additional: Tuple[str],
    num_backups: int,
    additional_cleanup: bool,
    additional_num_backups: int,
) -> None:
    """
    Backup the Docker Stack
    """
    configs = get_stacks(stack=stack)
    for config in configs:
        _backup_stack(
            stack=config,
            destination=destination,
            cleanup=cleanup,
            additional=additional,
            num_backups=num_backups,
            additional_cleanup=additional_cleanup,
            additional_num_backups=additional_num_backups,
        )


if __name__ == "__main__":
    cli()
