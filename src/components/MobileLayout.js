import React from 'react';
import Player from './Player';
import CentralMenu from './CentralMenu';

const MobileLayout = ({ gameState, onReset, onShowHistory }) => {
  return (
    <div 
      className="h-screen w-full flex flex-col bg-gray-900 text-gray-100 overflow-hidden"
      onContextMenu={(e) => e.preventDefault()}
      style={{
        userSelect: 'none',
        WebkitUserSelect: 'none',
        MozUserSelect: 'none',
        msUserSelect: 'none',
        WebkitTouchCallout: 'none'
      }}
    >
      {/* Player 2 (Top) */}
      <Player
        isPlayer1={false}
        initialLife={gameState.player2.life}
        maxLife={gameState.player2.maxLife}
        gameId={gameState.gameId}
      />

      {/* Menu Central (Middle) */}
      <CentralMenu 
        onReset={onReset}
        onShowHistory={onShowHistory}
      />

      {/* Player 1 (Bottom) */}
      <Player
        isPlayer1={true}
        initialLife={gameState.player1.life}
        maxLife={gameState.player1.maxLife}
        gameId={gameState.gameId}
      />
    </div>
  );
};

export default MobileLayout;
