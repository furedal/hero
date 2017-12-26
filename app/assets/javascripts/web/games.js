class Api  {

    getGame(gameId, callback) {
        $.get(`http://127.0.0.1:3000/api/v1/games/${gameId}`, data => {
            this.game = data.game;
            callback(data.game);
        });
    }

    attack(attacker, defender, callback) {
        $.ajax({
            url: `http://127.0.0.1:3000/api/v1/games/${this.game.id}/characters/${attacker}/attack`,
            method: 'put',
            data: {
                character: {
                    id: defender,
                },
            },
        }).done(data => {
            callback(data.character);
        });
    }

    move(character, toTile, callback) {
        $.ajax({
            url: `http://127.0.0.1:3000/api/v1/games/${this.game.id}/characters/${character}/move`,
            method: 'put',
            data: { path: [toTile.id] },
        }).done(data => {
            callback(data.character);
        });
    }
}

class Utils {
    static distanceToTile(tile1, tile2) {
        return Math.abs(tile1.x_position - tile2.x_position) + Math.abs(tile1.y_position - tile2.y_position);
    }

    static findReachableTiles(tiles, character) {
        const possibleReachableTiles = tiles.filter(tile => tile.id != character.tile.id
            && Utils.distanceToTile(character.tile, tile) <= character.speed
            && (tile.walkable || character.movement_type !== 'ground'));

        return possibleReachableTiles;
    }
}

class Game {
    constructor(gameId, canvas) {
        this.api = new Api();
        this.gameId = gameId;
        this.$canvas = $(canvas);
        this.api.getGame(gameId, game => {
            this.game = game;
            this.initGame();
        });
    }

    getCharacter(id) {
        let character = null;
        this.game.teams.some(t => {
            character = t.characters.find(c => c.id == id);
            return character != null;
        });
        return character;
    }

    initGame() {
        this.redrawCanvas();
    }

    redrawCanvas() {
        this.drawTiles();
        this.positionCharacters();
    }

    drawTiles() {
        this.$canvas.empty();
        this.game.tiles.forEach((tile, index) => {
            this.drawTile(tile, index);
        });
    }

    drawTile(tile, index) {
        const elem = $('<div></div>')
            .addClass('tile')
            .attr('data-tile-index', index)
            .attr('data-id', tile.id)
            .attr('data-x', tile.x_position)
            .attr('data-y', tile.y_position)
            .css('width', (100/this.game.width)+'%')
            .css('height', (100/this.game.height)+'%')
            .click(e => {
                this.onTileClick(elem);
            })
            .append('<span></span>');

        if (!tile.walkable) {
            elem.addClass('disabled');
        }

        this.$canvas.append(elem);
    }

    onTileClick(tile) {
        if (!this.selectedCharacter) {
            if (!tile.hasClass('opponent')) {
                // Select character
                this.selectedCharacter = tile.attr('data-character-id');
                this.drawReachableTiles(this.getCharacter(this.selectedCharacter));
            }
        } else if (this.selectedCharacter == tile.attr('data-character-id')) {
            // Deselect character
            this.clearReachableTiles();
            this.selectedCharacter = null;
        } else if (tile.attr('data-character-id')) {
            // Attack
            this.api.attack(this.selectedCharacter, tile.attr('data-character-id'), character => {
                this.updateCharacter(character);
                this.redrawCanvas();
            });
            this.selectedCharacter = null;
        } else {
            // Move
            this.api.move(this.selectedCharacter, this.game.tiles.find(t => t.id == tile.attr('data-id')), character => {
                this.updateCharacter(character);
                this.redrawCanvas();
            });
            this.selectedCharacter = null;
        }
    }

    positionCharacters() {
        this.game.teams.forEach((team, teamIndex) => {
            team.characters.forEach(character => {
                const tile = this.$canvas.find(`.tile[data-id=${character.tile.id}]`);
                this.positionCharacter(tile, character, teamIndex==1);
            });
        });
    }

    positionCharacter(tile, character, opponent) {
        tile.addClass('character')
        .attr('data-character-id', character.id);

        if (opponent) {
            tile.addClass('opponent');
        } else {
            tile.removeClass('opponent');
        }
        tile.find('span')
            .html(`<b>${character.name}</b></br> <b>health:</b> ${character.health}/${character.unit_health}</br> <b>units:</b> ${character.units}`);
    }

    updateCharacter(character) {
        this.game.teams.some((t, tIndex) => {
            const cIndex = t.characters.findIndex(c => c.id == character.id);
            if (cIndex != -1) {
                this.game.teams[tIndex].characters[cIndex] = character;
                return true;
            }
            return false;
        });
    }


    clearReachableTiles() {
        this.$canvas.find('.tile.reachable').removeClass('reachable');
    }

    drawReachableTiles(character) {
        this.clearReachableTiles();
        const tiles = Utils.findReachableTiles(this.game.tiles, character);
        tiles.forEach(tile => {
            this.$canvas.find(`.tile[data-id=${tile.id}]`).addClass('reachable');
        });
    }
}

jQuery(document).ready(function($) {
    function init() {
        new Game($('#game_canvas').attr('data-game-id'), $('#game_canvas'));
    }

    init();
});