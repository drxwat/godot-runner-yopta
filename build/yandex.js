let ysdk;
let leaderBoards;
let player;

const LEADERBOARD_NAME = "main";

function initSDK(callback) {
  YaGames.init()
    .then((_ysdk) => {
      ysdk = _ysdk;
      ysdk.features.LoadingAPI?.ready();
      Promise.all([ysdk.getLeaderboards(), ysdk.getPlayer()]).then(
        ([_leaderboards, _player]) => {
          leaderBoards = _leaderboards;
          player = _player;
          const isAuthenticated = player.getMode() !== "lite";
          if (!isAuthenticated) {
            callback(true, player.getName(), isAuthenticated, 0);
          } else {
            _leaderboards
              .getLeaderboardEntries(LEADERBOARD_NAME, {
                includeUser: true,
                quantityAround: 1,
              })
              .then((res) => {
                callback(true, player.getName(), isAuthenticated, res.userRank);
              })
              .catch(() => {
                callback(true, player.getName(), isAuthenticated, 0);
              });
          }
        }
      );
    })
    .catch(() => {
      callback(false);
    });
}

function updatePlayerScore(score) {
  ysdk.getLeaderboards().then((_leaderBoard) => {
    _leaderBoard.setLeaderboardScore(LEADERBOARD_NAME, score);
  });
}

// ysdk.isAvailableMethod('leaderboards.setLeaderboardScore')
