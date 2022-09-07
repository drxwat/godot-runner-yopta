
var ysdk;
var leaderBoards; 
var player;

var LEADERBOARD_NAME = 'main'

function initSDK(callback) {
    YaGames.init().then(_ysdk => {
        ysdk = _ysdk;
        Promise.all([ysdk.getLeaderboards(), ysdk.getPlayer()]).then(([_leaderboards, _player]) => {
            leaderBoards = _leaderboards
            player = _player;
            var is_authenticated = player.getMode() !== 'lite'
            if (!is_authenticated) {
                callback(true, player.getName(), is_authenticated, 0)
            } else {
                _leaderboards.getLeaderboardEntries(LEADERBOARD_NAME, { includeUser: true, quantityAround: 1 }).then((res) => {
                    callback(true, player.getName(), is_authenticated, res.userRank)
                }).catch(() => {
                    callback(true, player.getName(), is_authenticated, 0)
                })
            }
        })
    }).catch(() => {
        callback(false);
    });
}

function updatePlayerScore(score) {
    ysdk.getLeaderboards().then(_leaderBoard => {
        _leaderBoard.setLeaderboardScore(LEADERBOARD_NAME, score);
    });
}

// ysdk.isAvailableMethod('leaderboards.setLeaderboardScore')