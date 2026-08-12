"""Dark Tahoma matplotlib style: reusable helpers.

Import and call apply_dark_style() before plotting, then pull role colours from
PALETTE and style legends/grids with the LEGEND_KW / GRID_KW helpers.

    from style import apply_dark_style, PALETTE, LEGEND_KW, GRID_KW
    apply_dark_style()
    ax.plot(x, y, color=PALETTE["good"])
    ax.legend(**LEGEND_KW)
    ax.grid(True, axis="y", **GRID_KW)

The font is Tahoma. It is present on macOS and Windows; on a bare Linux box it
may be absent, in which case matplotlib falls back to the next family listed, so
the figure still renders (just not in Tahoma). Install Tahoma, or accept the
fallback, or swap "Tahoma" for an installed sans family.
"""

import matplotlib as mpl

# The rcParams that define the look: near-black canvas, light text, muted ticks.
DARK_RC = {
    "font.family": ["Tahoma", "DejaVu Sans", "sans-serif"],
    "figure.facecolor": "#121212",
    "axes.facecolor": "#0a0a0a",
    "savefig.facecolor": "#121212",
    "text.color": "#e0e0e0",
    "axes.labelcolor": "#cfcfcf",
    "axes.titlecolor": "#e8e8e8",
    "axes.edgecolor": "#333333",
    "xtick.color": "#9aa0aa",
    "ytick.color": "#9aa0aa",
}

# Role-based palette: each colour carries meaning, reused across panels so the
# reader learns the code once. Pick by role, not by aesthetics.
PALETTE = {
    "good": "#00ff66",  # a win, a recovered result, the desirable outcome
    "regression": "#ffb000",  # amber: a regression or a degraded-but-usable state
    "neutral": "#7aa2ff",  # blue: a neutral reference or an ideal baseline
    "fail": "#ff5566",  # red: a failure or the unusable baseline
}

# Legend styling that reads on the dark canvas.
LEGEND_KW = {
    "facecolor": "#1a1a1a",
    "labelcolor": "#e0e0e0",
    "edgecolor": "#333333",
    "fontsize": 9,
}

# Faint dotted grid that guides the eye without competing with the data.
GRID_KW = {"ls": ":", "color": "#2a2a2a"}


def apply_dark_style():
    """Apply the dark Tahoma rcParams globally for the current session."""
    mpl.rcParams.update(DARK_RC)


def footer(fig, text, y=0.01):
    """Add a muted one-line caption along the bottom of the figure."""
    fig.text(0.5, y, text, ha="center", color="#9aa0aa", fontsize=9)
