
import React, { useState, useEffect } from 'react';
import { Plus, Minus, RotateCcw, Users, Settings, X } from 'lucide-react';

const FORMATS = {
  classic: { name: 'Classic Constructed', life: 40 },
  blitz: { name: 'Blitz', life: 20 },
  commoner: { name: 'Commoner', life: 40 },
  clash: { name: 'Clash', life: 15 }
};

const HEROES_LIFE_MODIFIER = {
  'Iyslander': -5,
  'Kano': -5,
  'Oscilio': -10,
  'Verdance': -10
};

const SetupModal = ({ onClose, onStart }) => {
  const [format, setFormat] = useState('classic');
  const [player1Name, setPlayer1Name] = useState('');
  const [player1Hero, setPlayer1Hero] = useState('');
  const [player2Name, setPlayer2Name] = useState('');
  const [player2Hero, setPlayer2Hero] = useState('');

  const handleStart = () => {
    const baseLife = FORMATS[format].life;
    const p1Life = baseLife + (HEROES_LIFE_MODIFIER[player1Hero] || 0);
    const p2Life = baseLife + (HEROES_LIFE_MODIFIER[player2Hero] || 0);

    onStart({
      format,
      player1: { name: player1Name || 'Joueur 1', hero: player1Hero, life: p1Life, maxLife: p1Life, resources: 0 },
      player2: { name: player2Name || 'Joueur 2', hero: player2Hero, life: p2Life, maxLife: p2Life, resources: 0 }
    });
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-90 z-50 flex items-center justify-center p-4">
      <div className="bg-gray-800 rounded-lg max-w-md w-full p-6 max-h-[90vh] overflow-y-auto">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold">Configuration</h2>
          <button onClick={onClose} className="text-gray-400 hover:text-white">
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-2">Format</label>
            <select
              value={format}
              onChange={(e) => setFormat(e.target.value)}
              className="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 focus:outline-none focus:border-red-500"
            >
              {Object.entries(FORMATS).map(([key, val]) => (
                <option key={key} value={key}>{val.name} ({val.life} PV)</option>
              ))}
            </select>
          </div>

          <div className="border-t border-gray-700 pt-4">
            <h3 className="font-semibold mb-3">Joueur 1</h3>
            <input
              type="text"
              placeholder="Nom (optionnel)"
              value={player1Name}
              onChange={(e) => setPlayer1Name(e.target.value)}
              className="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 mb-3 focus:outline-none focus:border-red-500"
            />
            <select
              value={player1Hero}
              onChange={(e) => setPlayer1Hero(e.target.value)}
              className="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 focus:outline-none focus:border-red-500"
            >
              <option value="">Héros (optionnel)</option>
              <option value="Iyslander">Iyslander (-5 PV)</option>
              <option value="Kano">Kano (-5 PV)</option>
              <option value="Oscilio">Oscilio (-10 PV)</option>
              <option value="Verdance">Verdance (-10 PV)</option>
            </select>
          </div>

          <div className="border-t border-gray-700 pt-4">
            <h3 className="font-semibold mb-3">Joueur 2</h3>
            <input
              type="text"
              placeholder="Nom (optionnel)"
              value={player2Name}
              onChange={(e) => setPlayer2Name(e.target.value)}
              className="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 mb-3 focus:outline-none focus:border-red-500"
            />
            <select
              value={player2Hero}
              onChange={(e) => setPlayer2Hero(e.target.value)}
              className="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 focus:outline-none focus:border-red-500"
            >
              <option value="">Héros (optionnel)</option>
              <option value="Iyslander">Iyslander (-5 PV)</option>
              <option value="Kano">Kano (-5 PV)</option>
              <option value="Oscilio">Oscilio (-10 PV)</option>
              <option value="Verdance">Verdance (-10 PV)</option>
            </select>
          </div>

          <button
            onClick={handleStart}
            className="w-full bg-red-600 hover:bg-red-700 text-white py-4 rounded-lg font-semibold mt-6"
          >
            Commencer la partie
          </button>
        </div>
      </div>
    </div>
  );
};

const PlayerCounter = ({ player, onLifeChange, onResourceChange, isTop }) => {
  const adjustLife = (amount) => {
    onLifeChange(Math.max(0, player.life + amount));
  };

  const adjustResource = (amount) => {
    onResourceChange(Math.max(0, player.resources + amount));
  };

  const getLifeColor = () => {
    const percentage = (player.life / player.maxLife) * 100;
    if (percentage > 50) return 'text-green-400';
    if (percentage > 25) return 'text-yellow-400';
    return 'text-red-400';
  };

  return (
    <div className={`flex-1 flex flex-col bg-gray-800 ${isTop ? 'rotate-180' : ''}`}>
      {/* Life Counter */}
      <div className="flex-1 flex flex-col items-center justify-center p-6">
        <div className="text-center mb-4">
          <div className="text-sm text-gray-400 mb-1">{player.name}</div>
          {player.hero && <div className="text-xs text-gray-500">{player.hero}</div>}
        </div>

        <div className={`text-8xl font-bold mb-8 ${getLifeColor()}`}>
          {player.life}
        </div>

        <div className="grid grid-cols-3 gap-4 w-full max-w-sm mb-6">
          <button
            onClick={() => adjustLife(-1)}
            className="bg-red-600 hover:bg-red-700 active:bg-red-800 text-white rounded-lg h-20 flex items-center justify-center text-3xl font-bold"
          >
            -1
          </button>
          <button
            onClick={() => adjustLife(-5)}
            className="bg-red-700 hover:bg-red-800 active:bg-red-900 text-white rounded-lg h-20 flex items-center justify-center text-3xl font-bold"
          >
            -5
          </button>
          <button
            onClick={() => adjustLife(-10)}
            className="bg-red-800 hover:bg-red-900 active:bg-red-950 text-white rounded-lg h-20 flex items-center justify-center text-3xl font-bold"
          >
            -10
          </button>
        </div>

        <div className="grid grid-cols-3 gap-4 w-full max-w-sm">
          <button
            onClick={() => adjustLife(1)}
            className="bg-green-600 hover:bg-green-700 active:bg-green-800 text-white rounded-lg h-20 flex items-center justify-center text-3xl font-bold"
          >
            +1
          </button>
          <button
            onClick={() => adjustLife(5)}
            className="bg-green-700 hover:bg-green-800 active:bg-green-900 text-white rounded-lg h-20 flex items-center justify-center text-3xl font-bold"
          >
            +5
          </button>
          <button
            onClick={() => adjustLife(10)}
            className="bg-green-800 hover:bg-green-900 active:bg-green-950 text-white rounded-lg h-20 flex items-center justify-center text-3xl font-bold"
          >
            +10
          </button>
        </div>
      </div>

      {/* Resources Counter */}
      <div className="border-t border-gray-700 bg-gray-750 p-4">
        <div className="flex items-center justify-between max-w-sm mx-auto">
          <button
            onClick={() => adjustResource(-1)}
            className="bg-gray-700 hover:bg-gray-600 active:bg-gray-500 text-white rounded-lg w-16 h-16 flex items-center justify-center"
          >
            <Minus className="w-8 h-8" />
          </button>
          
          <div className="text-center">
            <div className="text-xs text-gray-400 mb-1">Ressources</div>
            <div className="text-4xl font-bold text-blue-400">{player.resources}</div>
          </div>

          <button
            onClick={() => adjustResource(1)}
            className="bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white rounded-lg w-16 h-16 flex items-center justify-center"
          >
            <Plus className="w-8 h-8" />
          </button>
        </div>
      </div>
    </div>
  );
};

export default function FabLifeCounter() {
  const [showSetup, setShowSetup] = useState(true);
  const [gameState, setGameState] = useState(null);
  const [history, setHistory] = useState([]);

  useEffect(() => {
    const saved = localStorage.getItem('fab-life-counter-state');
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        setGameState(parsed);
        setShowSetup(false);
      } catch (e) {
        // Ignore errors
      }
    }
  }, []);

  useEffect(() => {
    if (gameState) {
      localStorage.setItem('fab-life-counter-state', JSON.stringify(gameState));
    }
  }, [gameState]);

  const handleStart = (config) => {
    setGameState(config);
    setHistory([]);
    setShowSetup(false);
  };

  const handleReset = () => {
    if (confirm('Réinitialiser la partie ?')) {
      setGameState({
        ...gameState,
        player1: { ...gameState.player1, life: gameState.player1.maxLife, resources: 0 },
        player2: { ...gameState.player2, life: gameState.player2.maxLife, resources: 0 }
      });
      setHistory([]);
    }
  };

  const updatePlayer1Life = (newLife) => {
    setHistory([...history, { ...gameState }]);
    setGameState({
      ...gameState,
      player1: { ...gameState.player1, life: newLife }
    });
  };

  const updatePlayer1Resources = (newResources) => {
    setGameState({
      ...gameState,
      player1: { ...gameState.player1, resources: newResources }
    });
  };

  const updatePlayer2Life = (newLife) => {
    setHistory([...history, { ...gameState }]);
    setGameState({
      ...gameState,
      player2: { ...gameState.player2, life: newLife }
    });
  };

  const updatePlayer2Resources = (newResources) => {
    setGameState({
      ...gameState,
      player2: { ...gameState.player2, resources: newResources }
    });
  };

  const handleUndo = () => {
    if (history.length > 0) {
      const previous = history[history.length - 1];
      setGameState(previous);
      setHistory(history.slice(0, -1));
    }
  };

  if (showSetup) {
    return (
      <div className="min-h-screen bg-gray-900 text-gray-100">
        <SetupModal
          onClose={() => gameState && setShowSetup(false)}
          onStart={handleStart}
        />
      </div>
    );
  }

  if (!gameState) {
    return null;
  }

  return (
    <div className="h-screen flex flex-col bg-gray-900 text-gray-100 overflow-hidden">
      {/* Player 2 (Top, rotated) */}
      <PlayerCounter
        player={gameState.player2}
        onLifeChange={updatePlayer2Life}
        onResourceChange={updatePlayer2Resources}
        isTop={true}
      />

      {/* Middle Controls */}
      <div className="bg-gray-900 border-y border-gray-700 flex items-center justify-center gap-2 py-2 px-4">
        <button
          onClick={handleUndo}
          disabled={history.length === 0}
          className="bg-gray-700 hover:bg-gray-600 disabled:bg-gray-800 disabled:text-gray-600 text-white rounded-lg px-4 py-2 flex items-center gap-2 text-sm font-semibold"
        >
          <RotateCcw className="w-4 h-4" />
          Annuler
        </button>

        <button
          onClick={() => setShowSetup(true)}
          className="bg-gray-700 hover:bg-gray-600 text-white rounded-lg px-4 py-2 flex items-center gap-2 text-sm font-semibold"
        >
          <Settings className="w-4 h-4" />
          Config
        </button>

        <button
          onClick={handleReset}
          className="bg-red-600 hover:bg-red-700 text-white rounded-lg px-4 py-2 flex items-center gap-2 text-sm font-semibold"
        >
          <RotateCcw className="w-4 h-4" />
          Reset
        </button>
      </div>

      {/* Player 1 (Bottom) */}
      <PlayerCounter
        player={gameState.player1}
        onLifeChange={updatePlayer1Life}
        onResourceChange={updatePlayer1Resources}
        isTop={false}
      />
    </div>
  );
                }
